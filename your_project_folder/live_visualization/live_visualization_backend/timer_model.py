# Copyright (C) 2023, NG:ITL
from PySide6.QtCore import QObject, Signal, Property


def pad_left(string: str, length: int, padchar: str = "0") -> str:
    string = padchar * (length - len(string)) + string[0:length]
    return string


class Model(QObject):
    def __init__(self, millis: int, seconds: int, minutes: int) -> None:
        QObject.__init__(self)
        self._millis = millis
        self._seconds = seconds
        self._minutes = minutes

        self._sector_one_color = "grey"
        self._sector_two_color = "grey"
        self._sector_three_color = "grey"

        self._best_time = 27563000000
        self._best_sector_one = 30
        self._best_sector_two = 30
        self._best_sector_three = 30

        self._split_time = 0

    def set_timestamp(self, timestamp_ns: int) -> None:
        timestamp_ms = timestamp_ns // (1000 * 1000)

        millis = timestamp_ms % 1000
        seconds = (timestamp_ms // 1000) % 60
        minutes = (timestamp_ms // (1000 * 60)) % 60

        self.set_millis(millis)
        self.set_seconds(seconds)
        self.set_minutes(minutes)

    def get_millis(self) -> int:
        return self._millis

    def get_seconds(self) -> int:
        return self._seconds

    def get_minutes(self) -> int:
        return self._minutes

    def get_sector_one(self) -> str:
        return self._sector_one_color

    def get_sector_two(self) -> str:
        return self._sector_two_color

    def get_sector_three(self) -> str:
        return self._sector_three_color

    def get_best_time(self) -> int:
        return self._best_time

    def get_split_time(self) -> float:
        return self._split_time

    def get_best_time_formatted(self) -> str:
        timestamp_ms = self.get_best_time() // (1000 * 1000)
        millis = timestamp_ms % 1000
        seconds = (timestamp_ms // 1000) % 60
        minutes = (timestamp_ms // (1000 * 60)) % 60

        return "%s:%s:%s" % (
            pad_left(str(minutes), 2),
            pad_left(str(seconds), 2),
            pad_left(str(millis), 3),
        )

    def set_millis(self, millis: int) -> None:
        self._millis = millis
        self.millis_changed.emit()

    def set_seconds(self, seconds: int) -> None:
        self._seconds = seconds
        self.seconds_changed.emit()

    def set_minutes(self, minutes: int) -> None:
        self._minutes = minutes
        self.minutes_changed.emit()

    def set_best_time(self, time: int) -> None:
        self._best_time = time
        self.best_time_changed.emit()

    def set_first_sector_color(self, color: str) -> None:
        self._sector_one_color = color
        self.sector_one_color_changed.emit()

    def set_second_sector_color(self, color: str) -> None:
        self._sector_two_color = color
        self.sector_two_color_changed.emit()

    def set_third_sector_color(self, color: str) -> None:
        self._sector_three_color = color
        self.sector_three_color_changed.emit()

    def set_split_time(self, time: float) -> None:
        self._split_time = time
        self.split_time_changed.emit()

    def update_best_sector(self, sector_number: int, sector_time: float) -> None:
        match sector_number:
            case 1:
                self._best_sector_one = sector_time
            case 2:
                self._best_sector_two = sector_time
            case 3:
                self._best_sector_three = sector_time

    def get_sector_time_difference(self, sector_number: int, sector_time: float) -> float:
        match sector_number:
            case 1:
                return sector_time - self._best_sector_one
            case 2:
                return sector_time - self._best_sector_two
            case 3:
                return sector_time - self._best_sector_three

    def get_lap_time_difference(self, lap_time: int) -> float:
        return (lap_time - self._best_time) / 1000000000

    def update_best_time(self, new_best) -> None:
        if new_best < self.get_best_time() or self.get_best_time() == 0:
            self.set_best_time(new_best)

    def trigger_delta(self) -> None:
        print("Signal emitted")
        self.trigger_delta_signal.emit()

    @Signal
    def millis_changed(self) -> None:
        pass

    @Signal
    def seconds_changed(self) -> None:
        pass

    @Signal
    def minutes_changed(self) -> None:
        pass

    @Signal
    def best_time_changed(self) -> None:
        pass

    @Signal
    def start_stop_button_clicked(self) -> None:
        pass

    @Signal
    def reset_button_clicked(self) -> None:
        pass

    @Signal
    def state_changed(self) -> None:
        pass

    @Signal
    def sector_one_color_changed(self) -> None:
        pass

    @Signal
    def sector_two_color_changed(self) -> None:
        pass

    @Signal
    def sector_three_color_changed(self) -> None:
        pass

    @Signal
    def split_time_changed(self) -> None:
        pass

    @Signal
    def trigger_delta_signal(self) -> None:
        pass

    millis = Property(int, get_millis, set_millis, notify=millis_changed)
    seconds = Property(int, get_seconds, set_seconds, notify=seconds_changed)
    minutes = Property(int, get_minutes, set_minutes, notify=minutes_changed)

    best_time = Property(str, get_best_time_formatted, set_best_time, notify=best_time_changed)
    split_time = Property(float, get_split_time, set_split_time, notify=split_time_changed)

    sector_one_color = Property(str, get_sector_one, set_first_sector_color, notify=sector_one_color_changed)
    sector_two_color = Property(str, get_sector_two, set_second_sector_color, notify=sector_two_color_changed)
    sector_three_color = Property(str, get_sector_three, set_third_sector_color, notify=sector_three_color_changed)
