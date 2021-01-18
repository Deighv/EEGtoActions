# EEG To Action

## Installation

- Download python 3
- Download pip
- Clone repo
- Run in folder: `pip install -r requirements.txt`

## Running
* Equip EEG, turn on
* Launch openbci, connect, make sure levels are <10, resolve any sensor position issues
  * Stop Stream, Stop Session

* Start OpenBCI_LSL\openbci_lsl.py
 * Daisy Enabled
 * Changing anything else doesn't actually change anything and the streams are misindexed starting at 1 which is why the code starts at 1 instead of 0...
 * Use GUI to connect to board, start stream

* Run outputEEGData.py

* Launch SQL, ensure rows are being created


-------

outputEEGData.py - Takes data stream being piped out by openbci via LSL and inserts into a database per data sample (60/second), timestamp is built into DB/column

EEG.sql - DB structure


Ref -
sentdex experiment: https://github.com/Sentdex/BCI
