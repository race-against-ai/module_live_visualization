import pynng
import time
import json
import random

LEADERBOARD_SUB_ADDRESS = "ipc:///tmp/RAAI/leaderboard_database.ipc"

time.sleep(0.5)


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

with pynng.Rep0() as sock:
    sock.listen(LEADERBOARD_SUB_ADDRESS)
    while True:
        msg = sock.recv()
        content = msg.decode()
        if content == "leaderboard_request":
            print("Leaderboard requested")
            data = topic + leaderboard_json
            print("Sending leaderboard")
            sock.send(data.encode())