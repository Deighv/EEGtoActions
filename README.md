# EEG To Action

A system to extract EEG + Controller data while gaming, analyze the signals and create a model with Tensorflow in the effort of creating interface devices using EEG signals 

## Installation

* Download python 3
* Download pip
* Clone repo
* Run in folder: 'pip install -r requirements.txt'
* Install postgres, run SQL scripts in data folder, optionally use real passwords
* Backup of my database available here if you're unable to make your own data- https://drive.google.com/file/d/18oJ2Dt9TI7pDZOlMZYIfiuzEtJDtbdba/view?usp=sharing 
  * https://www.postgresql.org/docs/7.3/app-pgrestore.html 

## Database Structure
* Headset_Data - This table stores each series of signals from the EEG in individual columns+rows
* Controller_Data - This table stores the controller's state as of the moment the EEG signal came in
* Controller_Data_Normalized_View - This converts stick pushes into dpad cardinal directions (This assists with the final table..)
* Controller_Press_Index - This turns every state the controller can be in into a single number.  This allows for ML to compare signals to 82 indexed states, instead of trying to map it to each button press (which would also be possible in this system)- this is grabbed via a kind of cartesian join in the model layer

## Data Layer
* outputEEGData.py - This script reads signals incoming from an (Open BCI Ultracortex Mk 4) EEG. Each time a signal comes in (240/second on average), the system checks the controller state, and stores both in the database with the same timestamp  
* Equip EEG, turn on
* Launch openbci, connect, stream, check levels + resolve any sensor position issues
  * Stop Stream, Stop Session

* Run 'python openbci_lsl.py'
  * Daisy Enabled (Where 16 channels available)
  * Use GUI to connect to board, start stream

* Run 'python outputEEGData.py' to begin pulling down controller state+eeg data and putting into postgres
* Fire up pgAdmin, ensure rows are being created


## Model Layer

* Run 'python outputEEGData.py' - Work in Progress- have pulled down data to use + basic tweaks to get the data in the correct form
  

## Todo - Interface Layer
* Use model to create action:hardware emulation








Ref (and thanks)- sentdex experiment: https://github.com/Sentdex/BCI
