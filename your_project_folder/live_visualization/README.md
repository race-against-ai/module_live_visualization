# Live Visualization

Live visualization that shows live camera feed with timing overlays.

![Architecture](../../../doc/export/architecture.svg "architecture")

## Prerequisites

Grabbing the H.268 stream is currently done by a 3rd-Party node application called **voc-poc** [1].
Please refer to the projects README to set it up.

## Setup environment

To setup a development environment and install all requirements run the following commands (example for windows):

    python -m venv venv
    venv/Scripts/activate
    python -m pip install -r requirements.txt

## Usage

1. Run live_image_broker:


    cd ../live_image_broker
    venv/Scripts/activate
    python live_image_broker/main.py

2. Run **voc_poc** and ffmpeg:


    node index.js -o | ffmpeg -i - -f rawvideo -pix_fmt rgb24 tcp://127.0.0.1:50000

3. Run live_visualization


    python live_visualization_backend/live_visualization.py

## References

[1] https://github.com/fpv-wtf/voc-poc