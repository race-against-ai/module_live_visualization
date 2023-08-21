# Copyright (C) 2023, NG:ITL
from PySide6.QtCore import QObject, Signal, Property
from typing import List


class DriverModel(QObject):
    name_changed = Signal(name="name_changed")
    timeChanged = Signal()
    place_changed = Signal(name="place_changed")
    formatted_time_changed = Signal(name="formatted_time_changed")
    time_improved = Signal(name="time_improved")

    def __init__(self, name: str, time: float, place: int = None, formatted_time: str = "") -> None:
        QObject.__init__(self)
        self._name = name
        self._time = time
        self._place = place
        self._formatted_time = formatted_time
  
    def get_name(self) -> str:
        return self._name

    def get_time(self) -> float:
        return self._time
    
    def get_place(self) -> int:
        return self._place
    
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
        self.timeChanged.emit()

    def set_place(self, place: int) -> None:
        self._place = place
        self.place_changed.emit()

    name = Property(str, get_name, set_name, notify=name_changed)
    time = Property(float, get_time, set_time, notify=timeChanged)
    place = Property(int, get_place, set_place, notify=place_changed)
    formatted_time = Property(str, get_formatted_time, notify=formatted_time_changed)


class LeaderboardModel(QObject):
    leaderboard_updated = Signal(name="leaderboard_updated")
    new_driver_added = Signal(name="new_driver_added")

    def __init__(self, parent=None) -> None:
        super().__init__(parent)
        self._leaderboard_entries: List[DriverModel] = \
            []
        self._current_driver: DriverModel = None
        
    def get_leaderboard(self) -> list:
        return self._leaderboard_entries
    
    def clear_leaderboard(self) -> None:
        self._leaderboard_entries = []

    def set_new_driver(self, driver_object: DriverModel) -> None:
        self._current_driver = driver_object
        self.new_driver_added.emit()
    
    def check_if_driver_exists(self, driver_name: str) -> bool:
        for obj in self._leaderboard_entries:
            if obj.name == driver_name:
                return True
        return False
    
    def update_leaderboard(self, leaderboard: dict) -> None:
        pre_leaderboard = self._leaderboard_entries

        for entries in leaderboard:
            if not self.check_if_driver_exists(entries):
                driver = DriverModel(entries, leaderboard[entries])
                pre_leaderboard.append(driver)
                self.set_new_driver(driver)
                print("new driver added")
            else:
                for obj in self._leaderboard_entries:
                    if obj.name == entries:
                        if obj.time > leaderboard[entries]:
                            obj.time = leaderboard[entries]
                            obj.time_improved.emit()
                            print("updated time")
                            break

        #_leaderboard_entries sorted by dict value from lowest to highest
        self._leaderboard_entries.sort(key=lambda x: x.time)

        #delete all entries with index > 20
        del self._leaderboard_entries[20:]

        #add place to each entry
        for i in range(len(self._leaderboard_entries)):
            if(self._leaderboard_entries[i].place == (i + 1)):
                continue
            self._leaderboard_entries[i].set_place(i + 1)
        self.leaderboard_updated.emit()

    leaderboard = Property(list, get_leaderboard, update_leaderboard, notify=leaderboard_updated)
    new_driver = Property(DriverModel, lambda self: self._current_driver, notify=new_driver_added)



class ModelLV(QObject):

    def __init__(self) -> None:
        QObject.__init__(self)

    @Signal
    def reloadImage(self) -> None:
        pass

