# Copyright (C) 2023, NG:ITL
import os
import sys
from pathlib import Path
import select
import time
import pynng

from PySide6.QtGui import QGuiApplication, QImage
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QTimer, Qt, QSize, QSocketNotifier
from PySide6.QtQuick import QQuickImageProvider
from enum import IntEnum
from pathlib import Path
from json import dumps, load, dump

from live_visualization.live_visualization_model import ModelLV, DriverModel, LeaderboardModel
from live_visualization.timer_model import Model

# mypy: ignore-errors

CURRENT_DIR = Path(__file__).parent
CONFIG_FILE_PATH = CURRENT_DIR.parent / "live_visualization_config.json"


class State(IntEnum):
    RESET = 0
    RUNNING = 1
    PAUSED = 2
    STOPPED = 3


def resource_path() -> Path:
    base_path = getattr(sys, "_MEIPASS", Path(__file__).parent)
    return Path(base_path)


class StreamImageProvider(QQuickImageProvider):
    def __init__(self, width: int, height: int) -> None:
        super(StreamImageProvider, self).__init__(QQuickImageProvider.Image)
        self.img = QImage(width, height, QImage.Format_RGB888)

    def requestImage(self, id: str, size: QSize, requested_size: QSize) -> QImage:
        size = self.img.size()
        if requested_size.width() > 0 and requested_size.height() > 0:
            return self.img.scaled(requested_size, Qt.KeepAspectRatio)
        else:
            return self.img


class LiveVisualization:
    def __init__(self, config_path: Path = CURRENT_DIR.parent / "live_visualization_config.json") -> None:
        self.start_timestamp_ns = time.time_ns()
        self.diff = 0

        if not CONFIG_FILE_PATH.exists():
            with open(CONFIG_FILE_PATH, "w", encoding="utf-8") as config, open(
                CURRENT_DIR / "templates/live_visualization_config.json", "r", encoding="utf-8"
            ) as template_file:
                dump(load(template_file), config, indent=4)

        with open(config_path, "r", encoding="utf-8") as f:
            config = load(f)
            self.__stream_receiver_address: str = config["pynng"]["subscribers"]["stream_receiver"]["address"]
            self.__tracker_stream_receiver_address: str = config["pynng"]["subscribers"]["tracker_stream_receiver"][
                "address"
            ]
            self.__time_tracking_receiver_address: str = config["pynng"]["subscribers"]["time_tracking_receiver"][
                "address"
            ]
            self.__sound_server_status_receiver_address: str = config["pynng"]["subscribers"][
                "sound_server_status_receiver"
            ]["address"]
            self.__leaderboard_receiver_address: str = config["pynng"]["subscribers"]["leaderboard_receiver"]["address"]

            self.__vr_stream_height: int = config["image_dimensions"]["vr_stream"]["height"]
            self.__vr_stream_width: int = config["image_dimensions"]["vr_stream"]["width"]

            self.__tracker_stream_height: int = config["image_dimensions"]["tracker_stream"]["height"]
            self.__tracker_stream_width: int = config["image_dimensions"]["tracker_stream"]["width"]

            self.__stream_depth: int = config["image_dimensions"]["image_depth"]

        self.t_model = Model(0, 0, 0)

        self.leaderboard_model = LeaderboardModel()

        self.live_visualization_model = ModelLV()

        self.app = QGuiApplication(sys.argv)
        self.engine = QQmlApplicationEngine()
        self.tracker_stream_image_provider = StreamImageProvider(
            self.__tracker_stream_width, self.__tracker_stream_height
        )
        self.stream_image_provider = StreamImageProvider(self.__vr_stream_width, self.__vr_stream_height)

        self.engine.addImageProvider("tracker_stream", self.tracker_stream_image_provider)
        self.engine.addImageProvider("stream", self.stream_image_provider)

        self.engine.rootContext().setContextProperty("t_model", self.t_model)
        self.engine.rootContext().setContextProperty("live_visualization_model", self.live_visualization_model)
        self.engine.rootContext().setContextProperty("leaderboard_model", self.leaderboard_model)
        self.engine.load(resource_path() / "live_visualization/frontend/qml/main.qml")

        self.tracker_image_sub = pynng.Sub0()
        self.tracker_image_sub.subscribe("")
        self.tracker_image_sub.dial(self.__tracker_stream_receiver_address, block=False)

        self.image_sub = pynng.Sub0()
        self.image_sub.subscribe("")
        self.image_sub.dial(self.__stream_receiver_address, block=False)

        self.lap_sub = pynng.Sub0()
        self.lap_sub.subscribe("")
        self.lap_sub.dial(self.__time_tracking_receiver_address, block=False)

        self.leaderboard_sub = pynng.Sub0()
        self.leaderboard_sub.subscribe("")
        self.leaderboard_sub.dial(self.__leaderboard_receiver_address, block=False)

        self.sound_status_sub = pynng.Sub0()
        self.sound_status_sub.subscribe("")
        self.sound_status_sub.dial(self.__sound_server_status_receiver_address, block=False)

        self._tracker_image_socket_notifier = QSocketNotifier(self.tracker_image_sub.recv_fd, QSocketNotifier.Read)
        self._tracker_image_socket_notifier.activated.connect(self.tracker_image_receiver_callback)

        self._image_socket_notifier = QSocketNotifier(self.image_sub.recv_fd, QSocketNotifier.Read)
        self._image_socket_notifier.activated.connect(self.image_receiver_callback)

        self._lap_socket_notifier = QSocketNotifier(self.lap_sub.recv_fd, QSocketNotifier.Read)
        self._lap_socket_notifier.activated.connect(self.time_receiver)

        self._leaderboard_socket_notifier = QSocketNotifier(self.leaderboard_sub.recv_fd, QSocketNotifier.Read)
        self._leaderboard_socket_notifier.activated.connect(self.leaderboard_receiver)

        self._sound_status_socket_notifier = QSocketNotifier(self.sound_status_sub.recv_fd, QSocketNotifier.Read)
        self._sound_status_socket_notifier.activated.connect(self.sound_status_receiver)

        # timer for counting
        self.lapTimer = QTimer()
        self.lapTimer.timeout.connect(self.lapTimer_callback)
        self.image_count = 0

        # # current state of the timer
        self.timer_state = 0

    def run(self) -> None:
        # try:
        if not self.engine.rootObjects():
            sys.exit(-1)
        print("started")
        self.app.exec()
        # except:
        # print("failed")
        # pass

    def check_if_image_available_pynng(self) -> bool:
        socket_list = [self.tracker_image_sub.recv_fd]
        read_sockets, write_sockets, error_sockets = select.select(socket_list, [], [], 0)
        return self.tracker_image_sub in read_sockets

    def tracker_image_receiver_callback(self) -> None:
        try:
            data = self.tracker_image_sub.recv()
            self.tracker_stream_image_provider.img = QImage(
                data, self.__tracker_stream_width, self.__tracker_stream_height, QImage.Format_BGR888
            )
            self.live_visualization_model.reloadImage.emit()
        except:
            pass

    def image_receiver_callback(self) -> None:
        try:
            data = self.image_sub.recv()
            self.stream_image_provider.img = QImage(
                data, self.__vr_stream_width, self.__vr_stream_height, QImage.Format_RGB888
            )
            self.live_visualization_model.reloadImage.emit()
        except:
            pass

    # the counter for the timer, basically the timer itself
    def lapTimer_callback(self) -> None:
        current_timestamp_ns = time.time_ns()
        self.diff = current_timestamp_ns - self.start_timestamp_ns
        self.t_model.set_timestamp(self.diff)

    def start_stop_button_clicked(self) -> None:
        print("Button pressed")
        state = self.timer_state
        if state == State.RESET:
            self.start()
        elif state == State.PAUSED:
            self.start()
        elif state == State.RUNNING:
            self.pause()

    def reset_button_clicked(self) -> None:
        self.reset()

    def start(self) -> None:
        # a stopped timer has to be restarted completely
        if self.timer_state == State.STOPPED:
            self.diff = 0
            self.t_model.set_timestamp(0)

        self.start_timestamp_ns = time.time_ns() - self.diff
        self.lapTimer.start()
        self.timer_state = State.RUNNING

    def pause(self) -> None:
        if self.timer_state == State.PAUSED:
            self.start()
        else:
            self.lapTimer.stop()
            self.timer_state = State.PAUSED

    def reset(self) -> None:
        self.lapTimer.stop()
        self.diff = 0
        self.t_model.set_timestamp(0)
        self.timer_state = State.RESET

    def time_receiver(self) -> None:
        msg = self.lap_sub.recv()
        decoded_data: str = msg.decode()
        i = decoded_data.find(" ")
        decoded_data = decoded_data[i + 1 :]
        data = json.loads(decoded_data)
        print(data)

        if "lap_best_time" in data:
            print("Lap started!")
            # self.leaderboard_model.update_active_driver(data["current_driver"])

            self.t_model.set_best_time(int(data["lap_best_time"] * 1000000000))
            self.start_stop_button_clicked()

            self.t_model.update_best_sector(1, data["sector_1_best_time"])
            self.t_model.update_best_sector(2, data["sector_2_best_time"])
            self.t_model.update_best_sector(3, data["sector_3_best_time"])

        if "sector_number" in data:
            self._update_sector_color(data["sector_number"], data["type"])

            if data["sector_number"] == 1:
                self._update_sector_color(2, "grey")
                self._update_sector_color(3, "grey")

            if data["sector_number"] < 3:
                self.t_model.set_split_time(
                    self.t_model.get_sector_time_difference(data["sector_number"], data["sector_time"])
                )
                self.t_model.trigger_delta()

        if "lap_time" in data:
            self.reset_button_clicked()
            if data["lap_valid"]:
                self.t_model.set_split_time(self.t_model.get_lap_time_difference(data["lap_time"] * 1000000000))
                self.t_model.trigger_delta()
                self.set_leaderboard(data["current_driver"], data["lap_time"])

    def _update_sector_color(self, sector, color) -> None:
        match sector:
            case 1:
                self.t_model.set_first_sector_color(color)
            case 2:
                self.t_model.set_second_sector_color(color)
            case 3:
                self.t_model.set_third_sector_color(color)

    def set_leaderboard(self, driver: str, time: float) -> None:
        self.leaderboard_model.update_leaderboard({driver: time})

    def leaderboard_receiver(self) -> None:
        msg = self.leaderboard_sub.recv_msg()
        decoded_data: str = msg.bytes.decode()
        i = decoded_data.find(" ")
        decoded_data = decoded_data[i + 1 :]
        data = json.loads(decoded_data)
        print("leaderboard_receiver() called")

        self.leaderboard_model.update_leaderboard(data)

    def sound_status_receiver(self) -> None:
        msg = self.sound_status_sub.recv()
        print(msg.decode())
        if msg.decode() == "running":
            self.live_visualization_model.soundStarted.emit()
        elif msg.decode() == "stopped":
            self.live_visualization_model.soundStopped.emit()
        else:
            print("Invalid status!")


def main():
    print("starting visualizer...")

    live_visualization = LiveVisualization()
    live_visualization.run()
