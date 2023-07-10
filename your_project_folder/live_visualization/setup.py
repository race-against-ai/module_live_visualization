# Copyright (C) 2023, NG:ITL
from pathlib import Path
from setuptools import find_packages, setup

NAME = "live_visualization"
VERSION = "0.0.1"


def read(fname):
    return open(Path(__file__).parent / fname).read()


setup(
    name=NAME,
    version=VERSION,
    author="Torsten Wylegala",
    author_email="mail@twyleg.de",
    description=("Live visualization with camera image brackground and overlays"),
    license="GPL 3.0",
    keywords="=raai pyqt qtquick",
    url="https://github.com/twyleg",
    packages=find_packages(),
    long_description=read("README.md"),
    install_requires=[
        "pyside6==6.3.1",
        "pynng~=0.7.2"
    ],
    cmdclass={},
)
