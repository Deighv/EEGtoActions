import numpy as np
import tensorflow as tf
from tensorflow import keras
import psycopg2
#Start with left/right/up/down on stick (rounded to on/off) and ABXY - Can be pushing left/up and 2 buttons, 4 total
#Need SQL to pull data EEG and Controller Data
#Controller SQL will need to be fancy and pull down index/library needs to be made to translate the two- include left stick and dpad in OR
#Put into paired lists
#SQL for controller index ID (second number)
print("Connecting to Database")
conn = psycopg2.connect(database="eeg", user="postgres", password="penislol", host="127.0.0.1", port="5432")
print(conn)
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
    print("Controller Index Recieved")

with conn.cursor() as curs:
    curs.execute(EEGSql)
    EEG_State = curs.fetchall()
    print("EEG State Recieved")

Controller_State = np.asarray(Controller_State)
print("Controller State Numpy'd")
EEG_State = np.asarray(EEG_State)
print("EEG State Numpy'd")

#MLFoundations4.py will have a lot of info on how to get data in correct format

model = keras.Sequential([
    keras.layers.Flatten(16, 1000),
    keras.layers.Dense(128, activation=tf.nn.relu),
    keras.layers.Dense(81, activation=tf.nn.softmax)
])

print("model created")
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = 'sparse_categorical_crossentropy',
              metrics=['accuracy'])
print("model compiled, attempting fit with data")
model.fit(EEG_State, Controller_State, epochs=5)
#model.evaluate(test_images, test_labels)
model.save("mymodel")
print("model Saved?")