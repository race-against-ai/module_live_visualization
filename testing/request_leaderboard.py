import pynng
from time import sleep

address = "ipc:///tmp/RAAI/leaderboard_database.ipc"

with pynng.Req0() as sock:
    sock.dial(address)
    sleep(0.5)
    print("Sending request")
    sock.send(b"leaderboard_request")
    msg = sock.recv()
    print(msg.decode())
        