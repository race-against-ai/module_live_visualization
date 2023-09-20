import tkinter as tk
import pynng
from time import sleep

class DriverDataPublisher:
    def __init__(self, pub_address):
        self.PUB_ADDRESS = pub_address
        self.pub_socket = pynng.Pub0()
        self.pub_socket.listen(self.PUB_ADDRESS)
        sleep(1)

        self.app = tk.Tk()
        self.app.title("Driver Data Publisher")

        self.create_gui()

    def create_gui(self):
        self.driver_label = tk.Label(self.app, text="Enter the name of the current driver:")
        self.driver_entry = tk.Entry(self.app)
        self.send_button = tk.Button(self.app, text="Send Data", command=self.send_data)
        self.status_label = tk.Label(self.app, text="")
        self.app.bind('<Return>', lambda event=None: self.send_data())

        self.driver_label.grid(row=0, column=0, padx=10, pady=10)
        self.driver_entry.grid(row=0, column=1, padx=10, pady=10)
        self.send_button.grid(row=1, column=0, columnspan=2, padx=10, pady=10)
        self.status_label.grid(row=2, column=0, columnspan=2, padx=10, pady=10)

    def send_data(self):
        current_driver = self.driver_entry.get()
        data = "current_driver: " + current_driver
        self.pub_socket.send(data.encode('utf-8'))
        self.status_label.config(text="Data sent: " + data)
        
        # Clear the Entry widget after sending data
        self.driver_entry.delete(0, 'end')


    def run(self):
        self.app.mainloop()

if __name__ == "__main__":
    PUB_ADDRESS = "ipc:///tmp/RAAI/current_driver.ipc"
    app = DriverDataPublisher(PUB_ADDRESS)
    app.run()
