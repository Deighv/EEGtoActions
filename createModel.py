import numpy as np
import tensorflow as tf
from tensorflow import keras
import psycopg2
print("Connecting to Database")
conn = psycopg2.connect(database="eeg", user="postgres", password="penislol", host="127.0.0.1", port="5432")
print(conn)
#Get newest 1000 controller index states

controllerIndexSQL = """
SELECT cpi.controller_press_index_id
	FROM controller_data_normalized_view vw
RIGHT OUTER JOIN controller_press_index cpi ON
  cpi.dpad_right = vw.dpad_right AND
  cpi.dpad_left = vw.dpad_left AND
  cpi.dpad_up = vw.dpad_up AND
  cpi.dpad_down = vw.dpad_down AND
  vw.x = cpi.x AND
  vw.y = cpi.y AND
  vw.a = cpi.a AND
  vw.b = cpi.b
ORDER BY Time_ID ASC LIMIT 1000;
"""
controllerTrainingIndexSQL = """
SELECT cpi.controller_press_index_id
	FROM controller_data_normalized_view vw
RIGHT OUTER JOIN controller_press_index cpi ON
  cpi.dpad_right = vw.dpad_right AND
  cpi.dpad_left = vw.dpad_left AND
  cpi.dpad_up = vw.dpad_up AND
  cpi.dpad_down = vw.dpad_down AND
  vw.x = cpi.x AND
  vw.y = cpi.y AND
  vw.a = cpi.a AND
  vw.b = cpi.b
ORDER BY Time_ID ASC 
LIMIT (SELECT COUNT(controller_data_normalized_view.x) FROM controller_data_normalized_view) - 1000 offset 1000;
"""
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
  FROM headset_data 
GROUP BY Time_ID 
ORDER BY Time_ID ASC
LIMIT (SELECT COUNT(headset_data.channel0) FROM headset_data) - 1000 offset 1000;
"""
#Get newest 1000 eeg states
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
  FROM headset_data 
GROUP BY Time_ID 
ORDER BY Time_ID ASC
LIMIT 1000;
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


#Machine Learning Foundations was helpful in this- https://www.youtube.com/watch?v=_Z9TRANg4c0&list=PLOU2XLYxmsII9mzQ-Xxug4l2o04JBrkLV&index=1

model = tf.keras.models.Sequential([
    keras.layers.Flatten(),
    keras.layers.Dense(128, activation=tf.nn.relu),
    keras.layers.Dense(81, activation=tf.nn.softmax)
])

print("model created")
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = 'sparse_categorical_crossentropy',
              metrics=['accuracy'])
print("model compiled, attempting fit with data")
###
#Grab new eeg_state+controller_state to test model with
###
model.fit(EEG_Training_State, Controller_Training_State, epochs=5)

model.evaluate(EEG_State, Controller_State)
model.save("mymodel")
print("model Saved?")
