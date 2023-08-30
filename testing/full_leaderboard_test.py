import pynng
import time
import json
import random

LEADERBOARD_SUB_ADDRESS = "ipc:///tmp/RAAI/leaderboard.ipc"

# Open a socket and publish the json string
pub_socket = pynng.Pub0()
pub_socket.listen(LEADERBOARD_SUB_ADDRESS)

time.sleep(0.5)

while True:
# Define a list of driver names
    driver_dict = {
        "Hans": round(random.uniform(1, 100), 2), 
        "Georg": round(random.uniform(1, 100), 2),
        "Hure": round(random.uniform(1, 100), 2),
        "Kahba": round(random.uniform(1, 100), 2),
        "Kacke": round(random.uniform(1, 100), 2),
        "Kotze": round(random.uniform(1, 100), 2),
        "Kotzbrocken": round(random.uniform(1, 100), 2),
        "Kotzbröckchen": round(random.uniform(1, 100), 2),
        "Kotzbröckle": round(random.uniform(1, 100), 2),
        "Kotzbröckli": round(random.uniform(1, 100), 2)
    }

    print(driver_dict)

    # Convert the selected driver to a json string
    leaderboard_json = json.dumps(driver_dict)

    topic = "leaderboard: "
    data = topic + leaderboard_json

    pub_socket.send(data.encode("utf-8"))

    print("Leaderboard published")
    break
    time.sleep(3)
