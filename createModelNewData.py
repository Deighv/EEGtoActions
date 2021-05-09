#Flawed due to bad test dataset, need to grab every 10th row WHERE ID%13 = 0 ORDER BY ID
#WHERE internal or made up Row.ID is divisible by 10, get all those rows
#other bat uses where not divisible by 10
#SELECT tab.*,
#    row_number() OVER () as rnum
#  FROM tab;
import numpy as np
import tensorflow as tf
from tensorflow import keras
import psycopg2

class myCallback(tf.keras.callbacks.Callback):
  def on_epoch_end(self, epoch, logs={}):
    if(logs.get('accuracy')>=0.90):
      measAcc = str(round(logs.get("accuracy")*100,2))
      print("\nReached " + measAcc + "% accuracy, stopping training")
      self.model.stop_training = True
callbacks = myCallback()

print("Connecting to Database")
conn = psycopg2.connect(database="eeg", user="postgres", password="penislol", host="127.0.0.1", port="5432")
#conn = psycopg2.connect(database="eeg", user="postgres", password="penislol", host="127.0.0.1", port="5432")
print(conn)

#now only checking for left/right as proof of concept

#Get Every 10th row to check against
controllerIndexSQL = """
SELECT
(CASE 
   WHEN dpad_right = true THEN 1
   WHEN dpad_left = true THEN 2
   ELSE 0
END)
as LeftRight
    FROM controller_data_normalized_view
WHERE RIGHT(CAST(Row_Index AS TEXT), 1) = '0'
ORDER BY Time_ID ASC
"""

#Get all rows not every 10th
controllerTrainingIndexSQL = """
SELECT
(CASE 
   WHEN dpad_right = true THEN 1
   WHEN dpad_left = true THEN 2
   ELSE 0
END)
as LeftRight
    FROM controller_data_normalized_view
WHERE RIGHT(CAST(Row_Index AS TEXT), 1) != '0'
ORDER BY Time_ID ASC
"""

#Get every 10th EEG row
EEGSql = """
SELECT  
ROUND(SUM(GREATEST(channel0, 0)),0),
ROUND(SUM(GREATEST(channel1, 0)),0),
ROUND(SUM(GREATEST(channel2, 0)),0),
ROUND(SUM(GREATEST(channel3, 0)),0),
ROUND(SUM(GREATEST(channel4, 0)),0),
ROUND(SUM(GREATEST(channel5, 0)),0),
ROUND(SUM(GREATEST(channel6, 0)),0),
ROUND(SUM(GREATEST(channel7, 0)),0),
ROUND(SUM(GREATEST(channel8, 0)),0),
ROUND(SUM(GREATEST(channel9, 0)),0),
ROUND(SUM(GREATEST(channel10, 0)),0),
ROUND(SUM(GREATEST(channel11, 0)),0),
ROUND(SUM(GREATEST(channel12, 0)),0),
ROUND(SUM(GREATEST(channel13, 0)),0),
ROUND(SUM(GREATEST(channel14, 0)),0),
ROUND(SUM(GREATEST(channel15, 0)),0)
  FROM headset_data a
INNER JOIN controller_data_normalized_view b
  ON a.Time_ID = b.Time_ID
WHERE RIGHT(CAST(Primary_Key AS TEXT), 1) = '0'
GROUP BY a.Time_ID 
ORDER BY a.Time_ID ASC

"""

#Get all rows not ending in 0
eegTrainingDataSQL = """
SELECT  
ROUND(SUM(GREATEST(channel0, 0)),0),
ROUND(SUM(GREATEST(channel1, 0)),0),
ROUND(SUM(GREATEST(channel2, 0)),0),
ROUND(SUM(GREATEST(channel3, 0)),0),
ROUND(SUM(GREATEST(channel4, 0)),0),
ROUND(SUM(GREATEST(channel5, 0)),0),
ROUND(SUM(GREATEST(channel6, 0)),0),
ROUND(SUM(GREATEST(channel7, 0)),0),
ROUND(SUM(GREATEST(channel8, 0)),0),
ROUND(SUM(GREATEST(channel9, 0)),0),
ROUND(SUM(GREATEST(channel10, 0)),0),
ROUND(SUM(GREATEST(channel11, 0)),0),
ROUND(SUM(GREATEST(channel12, 0)),0),
ROUND(SUM(GREATEST(channel13, 0)),0),
ROUND(SUM(GREATEST(channel14, 0)),0),
ROUND(SUM(GREATEST(channel15, 0)),0)
  FROM headset_data a
INNER JOIN controller_data_normalized_view b
  ON a.Time_ID = b.Time_ID
WHERE RIGHT(CAST(Primary_Key AS TEXT), 1) != '0'
GROUP BY a.Time_ID 
ORDER BY a.Time_ID ASC
"""

with conn.cursor() as curs:
    curs.execute(controllerIndexSQL)
    Controller_State = curs.fetchall()
    print("Controller Test Index Recieved")

with conn.cursor() as curs:
    curs.execute(EEGSql)
    EEG_State = curs.fetchall()
    print("EEG Test States Recieved")

with conn.cursor() as curs:
    curs.execute(eegTrainingDataSQL)
    EEG_Training_State = curs.fetchall()
    print("EEG Training State Recieved")

with conn.cursor() as curs:
    curs.execute(controllerTrainingIndexSQL)
    Controller_Training_State = curs.fetchall()
    print("Controller Training State Recieved")

Controller_State = np.asarray(Controller_State)
Controller_State = Controller_State.astype(int)
print("Controller Test State Numpy'd")

EEG_State = np.asarray(EEG_State)
EEG_State = EEG_State.astype(int)
print("EEG Test State Numpy'd")

Controller_Training_State = np.asarray(Controller_Training_State)
Controller_Training_State = Controller_Training_State.astype(int)
print("Controller Training Data Numpy'd")

EEG_Training_State = np.asarray(EEG_Training_State)
EEG_Training_State = EEG_Training_State.astype(int)
print("EEG Training Data Numpy'd")


#need to figure out how to reshape the data to better prepare it for modeling
#Reshape, 60k is for number of images, 28 is width/height, 1 is color (actually 0-255 divided by 255)
#1413885(352749) number of rows in db-1000 for testing
#reshape size wants to be whatever number it guesses at/16?  
#16 is number of channels
#1 is dimensions in each array (just a row)
#Final number is the range of eeg data after dividing by highest number
#could normalize this to be in scale with each channel not by overall highest
#Need to set reshape size to be number of rows dynamically

#EEG_Training_State=EEG_Training_State.reshape(Number of Rows from eegTrainingDataSQL, Number of Channels, Number of Rows, Range of result of Data)
EEG_Training_State=EEG_Training_State.reshape(28314, 16, 1, 1)

#ML likes to deal with smaller values (IIRC), so scale the numbers down via the max sensor reading
EEG_Training_State=EEG_Training_State / 68645

#EEG_Training_State=EEG_Training_State.reshape(Number of Rows in EEGSql, 16, 1, 1)
EEG_State = EEG_State.reshape(3145, 16, 1, 1)
EEG_State=EEG_State/ 68645

#3 is the number of options we want to choose between
model = tf.keras.models.Sequential([
    keras.layers.Flatten(),
    keras.layers.Dense(64, activation=tf.nn.relu),
    keras.layers.Dense(3, activation=tf.nn.softmax)
])

print("compiling model..")
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = 'sparse_categorical_crossentropy',
              metrics=['accuracy'])
print("model compiled, attempting fit with data")
###
#Grab new eeg_state+controller_state to test model with
###
#model.fit(EEG_Training_State, Controller_Training_State, epochs=50, callbacks=[callbacks])
model.fit(EEG_Training_State, Controller_Training_State, epochs=50)
print("Model Fit Complete, Begin Eval")
model.evaluate(EEG_State, Controller_State)
model.save("mymodel")
print("model Saved?")
