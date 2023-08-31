# Copyright (C) 2023, NG:ITL
from PySide6.QtCore import QObject, Signal, Property
from typing import List
from time import sleep

# mypy: ignore-errors
class DriverModel(QObject):
    name_changed = Signal(name="nameChanged")
    time_changed = Signal(name="timeChanged")
    position_changed = Signal(name="positionChanged")
    formatted_time_changed = Signal(name="formatted_time_changed")
    time_improved = Signal(name="time_improved")

    def __init__(self, name: str, time: float, position: int = None, formatted_time: str = "") -> None:
        QObject.__init__(self)
        self._name = name
        self._time = time
        self._position = position
        self._formatted_time = formatted_time
  
    def get_name(self) -> str:
        return self._name

    def get_time(self) -> float:
        return self._time
    
    def get_position(self) -> int:
        return self._position
    
    def get_formatted_time(self) -> str:
        minutes = int(self._time / 60)
        seconds = int(self._time % 60)
        milliseconds = int((self._time - int(self._time)) * 1000)
        return f"{minutes:02d}:{seconds:02d}.{milliseconds:03d}"

    def set_name(self, name: str) -> None:
        self._name = name
        self.name_changed.emit()

    def set_time(self, time: float) -> None:
        self._time = time
        self.time_changed.emit()

    def set_position(self, position: int) -> None:
        self._position = position
        self.position_changed.emit()

    name = Property(str, get_name, set_name, notify=name_changed)
    time = Property(float, get_time, set_time, notify=time_changed)
    position = Property(int, get_position, set_position, notify=position_changed)
    formatted_time = Property(str, get_formatted_time, notify=formatted_time_changed)


class LeaderboardModel(QObject):
    leaderboard_updated_signal = Signal(name="leaderboardUpdated")
    new_driver_added_signal = Signal(DriverModel, name="newDriverAdded", arguments=["newDriverModel"])

    def __init__(self, parent=None) -> None:
        super().__init__(parent)
        self._leaderboard_entries: List[DriverModel] = []
        self._current_driver: DriverModel = None
        
    def get_leaderboard(self) -> list:
        return self._leaderboard_entries
    
    def clear_leaderboard(self) -> None:
        self._leaderboard_entries = []

    def check_if_driver_exists(self, driver_name: str) -> bool:
        for obj in self._leaderboard_entries:
            if obj.name == driver_name:
                return True
        return False

    def sort_leaderboard(self) -> None:
        self._leaderboard_entries.sort(key=lambda x: x.time)
        for i in range(len(self._leaderboard_entries)):
            self._leaderboard_entries[i].set_position(i)
    
    def update_leaderboard(self, updated_leaderboard: dict) -> None:
        for updated_driver_name in updated_leaderboard:
            updated_driver_time = updated_leaderboard[updated_driver_name]
            if not self.check_if_driver_exists(updated_driver_name):
                new_driver_model = DriverModel(updated_driver_name, updated_driver_time)
                self._leaderboard_entries.append(new_driver_model)
                self.new_driver_added_signal.emit(new_driver_model)
                self.sort_leaderboard()
                print("new driver added")
            else:
                for existing_driver_entry in self._leaderboard_entries:
                    if existing_driver_entry.name == updated_driver_name:
                        if updated_driver_time < existing_driver_entry.time:
                            existing_driver_entry.time = updated_driver_time
                            self.sort_leaderboard()
                            print(f"Updated time: Driver=\"{updated_driver_name}\", Time=\"{updated_driver_time}\"")

        self.sort_leaderboard()
        self.leaderboard_updated_signal.emit()

    leaderboard = Property(list, get_leaderboard, update_leaderboard, notify=leaderboard_updated_signal)



class ModelLV(QObject):

    def __init__(self) -> None:
        QObject.__init__(self)

    @Signal
    def reloadImage(self) -> None:
        pass

