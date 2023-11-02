import tkinter as tk
import pynng
from time import sleep
import json


class DriverDataPublisher:
    def __init__(self, pub_address, req_address):
        self.status_label = None
        self.search_button = None
        self.create_button = None
        self.driver_entry = None
        self.driver_label = None

        self.selected_driver = None
        self.listbox = None
        self.click_count = 0
        self.saved_drivers = []
        self.drivers = [
           {
            "id": "4823662a-29c5-47d7-bdba-68baa2825990", 
            "name": "Dummy", 
            "email": "example@email.test", 
            "created": "2023-11-02-08-58-03"
            } 
        ]

        self.PUB_ADDRESS = pub_address
        self.pub_socket = pynng.Pub0()
        self.pub_socket.listen(self.PUB_ADDRESS)
        sleep(1)

        self.req_socket = pynng.Req0()
        self.req_socket.dial(req_address, block=False)

        self.app = tk.Tk()
        self.app.title("Driver Data Publisher")

        self.create_gui()

    def create_gui(self):
        self.driver_label = tk.Label(self.app, text="Enter the name:")
        self.driver_entry = tk.Entry(self.app, width=50)
        self.search_button = tk.Button(self.app, text="Search", command=self.search_driver, width=10)
        self.create_button = tk.Button(self.app, text="Create", command=self.create_driver, width=10)
        self.refresh_button = tk.Button(self.app, text="Refresh", command=self.refresh_driver, width=10)
        self.status_label = tk.Label(self.app, text="")
        self.app.bind("<Return>", lambda event=None: self.send_data())

        self.driver_label.grid(row=0, column=0, padx=10, pady=10)
        self.driver_entry.grid(row=0, column=1, padx=10, pady=10)
        self.search_button.grid(row=1, column=0, padx=10, pady=10)
        self.create_button.grid(row=1, column=1, padx=10, pady=10)
        self.refresh_button.grid(row=2, column=1, padx=10, pady=10)
        self.status_label.grid(row=3, column=0, columnspan=2, padx=10, pady=10)

        self.listbox = tk.Listbox(self.app, width=70, height=10)
        self.listbox.grid(row=4, column=0, columnspan=2, padx=10, pady=10)

        self.listbox.bind("<<ListboxSelect>>", self.on_select)
        self.scrollbar = tk.Scrollbar(self.app, command=self.listbox.yview)
        self.scrollbar.grid(row=4, column=2, sticky='ns')

        self.show_list()
    
    def show_list(self):
        for driver in self.drivers:
            self.listbox.insert("end", f"{driver['name']}       |       {driver['id']}")

    def on_select(self, event):
        index = self.listbox.curselection()[0]
        selected_driver = self.listbox.get(index)

        if selected_driver == self.selected_driver:
            self.click_count += 1
        
        else:
            self.click_count = 1
            self.selected_driver = selected_driver

        if self.click_count == 2:
            driver_name = selected_driver.split("|")[0].strip()
            driver_id = selected_driver.split("|")[1].strip()
            print(f"Sending driver id: {driver_id}")
            try:
                response = self.req_socket.send(f"change_driver: {driver_id}".encode("utf-8"))
    
                response = self.req_socket.recv().decode("utf-8")
                print(response)
            except Exception as e:
                print(e)
            self.send_data(driver_name)
            self.click_count = 0

    def send_data(self, driver_name):
        data = "current_driver: " + driver_name
        self.pub_socket.send(data.encode("utf-8"))
        self.status_label.config(text="Data sent: " + data)

        # Clear the Entry widget after sending data
        self.driver_entry.delete(0, "end")

    def refresh_driver(self):
        print("Refresh driver")
        data = 'get_drivers'
        self.req_socket.send(data.encode("utf-8"))
        response = self.req_socket.recv().decode("utf-8")

        if response == "No Driver found":
            self.status_label.config(text="No driver found")
        
        else:
            response = json.loads(response)
            # search for driver
            self.saved_drivers = response
            self.drivers = self.saved_drivers
            self.listbox.delete(0, "end")
            self.show_list()

    def search_driver(self):
        print("Search driver")
        name = self.driver_entry.get()
        result = [driver for driver in self.saved_drivers if driver["name"] == name]
        if result:
            self.status_label.config(text="Found driver: " + name)
            self.drivers = result
            self.listbox.delete(0, "end")
            self.show_list()
        else:
            self.status_label.config(text="No driver found")
    
    def create_driver(self):
        name = self.driver_entry.get()
        data = f'post_driver: {name}'
        self.req_socket.send(data.encode("utf-8"))
        response = self.req_socket.recv().decode("utf-8")
        if response:
            try:
                self.drivers.append(json.loads(response))
                self.status_label.config(text="created driver: " + name)
                self.listbox.delete(0, "end")
                self.show_list()
            except Exception as e:
                print(e)
                self.status_label.config(text="driver creation failed")
        else:
            self.status_label.config(text="driver creation failed")



    def run(self):
        self.app.mainloop()


if __name__ == "__main__":
    PUB_ADDRESS = "ipc:///tmp/RAAI/current_driver.ipc"
    REQ_ADDRESS = "ipc:///tmp/RAAI/rest_api.ipc"
    app = DriverDataPublisher(PUB_ADDRESS, REQ_ADDRESS)
    app.run()
