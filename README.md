# RAAI Module Live Visualization  

The **Live Visualization Module** is a component of the Race Against AI system. It displays a live video feed from the car or tracking system, alongside a leaderboard featuring the top 20 drivers stored in the database. Additionally, the module includes a timer that shows the current lap time for the ongoing race.  

## Features  

- **Live Video Feed**: Displays real-time footage from the car or tracking system.  
- **Leaderboard**: Shows the top 20 drivers ranked by their performance, sourced from the database.  
- **Lap Timer**: Provides a real-time display of the current lap time during a race.  

## Structure  

The module is built to work seamlessly with the RAAI ecosystem:  

- **Leaderboard Data**: Fetched dynamically from the database to reflect real-time updates.  
- **Live Video Feed**: Integrated with the car's video system or external tracking mechanisms.  
- **Timer**: Designed for precise timekeeping during races.  

## Usage  

The Live Visualization Module can be launched as part of the RAAI system using the following steps:  

1. **Set Up a Python Virtual Environment**:  
   ```bash
   python -m venv venv
   source venv/bin/activate
   ```  

2. **Install Dependencies**:  
   ```bash
   pip install -r requirements.txt
   ```  

3. **Run the Module**:  
   ```bash
   python main.py
   ```  

Once running, the module will display the live feed, leaderboard, and timer within the designated visualization interface.  
