# Copyright (C) 2023, NG:ITL
import versioneer
from pathlib import Path
from setuptools import find_packages, setup


def read(fname):
    return open(Path(__file__).parent / fname).read()


setup(
    name="raai_module_live_visualization",
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    author="NGITL",
    author_email="calvinteuber7@gmail.com",
    description="Live visualization for RaceAgainstAI to visualize the camera feed, lap times and the track position",
    license="GPL 3.0",
    keywords="live visualization",
    url="https://github.com/vw-wob-it-edu-ngitl/raai_module_live_visualization",
    packages=find_packages(),
    long_description=read("README.md"),
    install_requires=["pynng~=0.7.2"],
)
