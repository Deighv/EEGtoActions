# EEG To Action

## Installation

* Download python 3
* Download pip
* Clone repo
* Run in folder: 'pip install -r requirements.txt'
* Install postgres, run SQL scripts in data folder, optionally use real passwords
* Backup of my data available here- https://drive.google.com/file/d/18oJ2Dt9TI7pDZOlMZYIfiuzEtJDtbdba/view?usp=sharing

## Database Structure
* Headset_Data - This table stores each series of signals from the EEG in individual columns+rows
* Controller_Data - This table stores the controller's state as of the moment the EEG signal came in
* Controller_Data_Normalized_View - This converts stick pushes into dpad cardinal directions (This assists with the final table..)
* Controller_Press_Index - This turns every state the controller can be in into a single number.  This allows for ML to compare signals to 82 indexed states, instead of trying to map it to each button press (which would also be possible in this system)- this is grabbed via a kind of cartesian join in the model layer

## Data Layer
* outputEEGData.py - This script reads signals incoming from an (Open BCI Ultracortex Mk 4) EEG. Each time a signal comes in (240/second on average), the system checks the controller state, and stores both in the database with the same timestamp  
* Equip EEG, turn on
* Launch openbci, connect, make sure levels are <10, resolve any sensor position issues
  * Stop Stream, Stop Session

* Run 'python openbci_lsl.py'
  * Daisy Enabled
  * Changing anything else doesn't actually change anything and the streams are misindexed starting at 1 which is why the code starts at 1 instead of 0...
  * Use GUI to connect to board, start stream

* Run 'python outputEEGData.py' to begin pulling down controller state+eeg data and putting into postgres
* Fire up pgAdmin, ensure rows are being created


## Model Layer

* Run 'python outputEEGData.py' - close(ish?) but data isn't being pushed into model in the correct format
  * most of the data prep is being done in SQL
  

## Todo - Interface Layer
* Use model to create action:hardware emulation








Ref (and thanks)- sentdex experiment: https://github.com/Sentdex/BCI
