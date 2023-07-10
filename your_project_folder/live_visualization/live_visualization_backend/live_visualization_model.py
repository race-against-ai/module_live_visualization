# Copyright (C) 2023, NG:ITL
from PySide6.QtCore import QObject, Signal, Property


class ModelLV(QObject):
    def __init__(self) -> None:
        QObject.__init__(self)

    @Signal
    def reloadImage(self) -> None:
        pass
