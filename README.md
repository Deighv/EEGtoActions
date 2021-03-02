# EEG To Action

A system to store EEG Data alongsite an input device, in an effort to create a model via machine learning to interpret brain signals as a medium for input devices

## Installation

* Download python 3
* Download pip
* Clone repo
* Run in folder: 'pip install -r requirements.txt'
* Install postgres, run SQL scripts in data folder, optionally use real passwords
* Backup of my database available here if you're unable to make your own data- https://drive.google.com/file/d/18oJ2Dt9TI7pDZOlMZYIfiuzEtJDtbdba/view?usp=sharing 
  * I've accomplished this via making the eeg database in postgres, running the database creation script, and restoring the database via interface to the file above

## Running and storing data
* Equip EEG, turn on
* Run 'python openbci_lsl.py'
  * Daisy Enabled+16 channels
  * Use GUI to connect to board, start stream to LSL for scripts to pick up on

* Run 'python outputEEGData.py' to pull down data simultaneously from EEG+Controller
* (optional) Fire up pgAdmin, ensure rows are being created

## Creating Model (post data collection/importing DB)
* run 'python createModel.py' 
* Model pulls data from all rows save most recent 1000 (this needs to change to better represent data) and compares it to all data entries minus that 1000
* I can only imagine there is significant room for improvement here

## Database Structure
* Headset_Data - This table stores each series of signals from the EEG in individual columns+rows
* Controller_Data - This table stores the controller's state as of the moment the EEG signal came in
* Controller_Data_Normalized_View - This converts stick pushes into dpad cardinal directions (This assists with the final table..)
* Controller_Press_Index - This turns every state the controller can be in into a single number.  This allows for ML to compare signals to 82 indexed states, instead of trying to map it to each button press.  Currently this is backed down to reading left/straight/right in an effort to proof of concept

## Todo - Interface Layer
* Use model to create action:hardware emulation








Ref (and thanks)- sentdex experiment: https://github.com/Sentdex/BCI
