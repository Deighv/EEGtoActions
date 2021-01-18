# EEG To Action

## Installation

 * Download python 3
 * Download pip
 * Clone repo
 * Run in folder: 'pip install -r requirements.txt'
 * Install postgres, run SQL scripts in data folder, optionally use real passwords

## Data Layer
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

* Run 'python outputEEGData.py' 
  * Pulls data via SQL to prep for model- currently data is not being submitted in the correct format

## Todo - Interface Layer
* Use model to create action:hardware emulation






Ref (and thanks)- sentdex experiment: https://github.com/Sentdex/BCI