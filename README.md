# EEG To Action

A system to store EEG Data alongsite an input device, in an effort to create a model via machine learning to interpret brain signals as a medium for input devices

## Installation

* Download python 3
* Download pip
* Clone repo
* Run in folder: 'pip install -r requirements.txt'
* Install postgres, run SQL scripts in data folder, optionally use real passwords
* Backup of my database available here if you're unable to make your own data- https://drive.google.com/file/d/18oJ2Dt9TI7pDZOlMZYIfiuzEtJDtbdba/view?usp=sharing 
  * https://www.postgresql.org/docs/7.3/app-pgrestore.html 

## Running
* outputEEGData.py - This script reads signals incoming from an (Open BCI Ultracortex Mk 4) EEG. Each time a signal comes in (240/second on average), the system checks the controller state, and stores both in the database with the same timestamp  
* Equip EEG, turn on
* Run 'python openbci_lsl.py'
  * Daisy Enabled+16 channels
  * Use GUI to connect to board, start stream for LSL for scripts to pick up on

* Run 'python outputEEGData.py' to pull down data simultaneously from EEG+Controller
* Fire up pgAdmin, ensure rows are being created
* 
## Creating Model
* run 'python createModel.py'
* Model pulls data from all rows save most recent 1000 (this needs to change to better represent data) and compares it to all data entries minus that 1000
* I can only imagine there is significant room for improvement here

## Database Structure
* Headset_Data - This table stores each series of signals from the EEG in individual columns+rows
* Controller_Data - This table stores the controller's state as of the moment the EEG signal came in
* Controller_Data_Normalized_View - This converts stick pushes into dpad cardinal directions (This assists with the final table..)
* Controller_Press_Index - This turns every state the controller can be in into a single number.  This allows for ML to compare signals to 82 indexed states, instead of trying to map it to each button press (which would also be possible in this system)- this is grabbed via a kind of cartesian join in the model layer



## Model Layer

* Run 'python outputEEGData.py' - Work in Progress- have pulled down data to use + basic tweaks to get the data in the correct form
  

## Todo - Interface Layer
* Use model to create action:hardware emulation








Ref (and thanks)- sentdex experiment: https://github.com/Sentdex/BCI
