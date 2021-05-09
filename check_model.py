from pylsl import StreamInlet, resolve_stream
import numpy as np
import time
import matplotlib.pyplot as plt
from matplotlib import style
from collections import deque
import cv2
import os
import random
import tensorflow as tf


MODEL_NAME = "mymodel"  
reshape = (-1, 16, 1)
model = tf.keras.models.load_model(MODEL_NAME)
model.predict( np.zeros((32,16,60)).reshape(reshape))
#model = model/ 68645


# first resolve an EEG stream on the lab network
#Connecting: cyton, 16ch, 60hz,com 3
print("Finding Data Streams")
streams = resolve_stream('type', 'EEG')
#accStream = StreamInlet(streams[0]) #Accelerometer
inlet = StreamInlet(streams[0]) #timeseries 
print("Streams Resolved")


WIDTH = 800
HEIGHT = 800
SQ_SIZE = 50
MOVE_SPEED = 1

square = {'x1': int(int(WIDTH)/2-int(SQ_SIZE/2)), 
          'x2': int(int(WIDTH)/2+int(SQ_SIZE/2)),
          'y1': int(int(HEIGHT)/2-int(SQ_SIZE/2)),
          'y2': int(int(HEIGHT)/2+int(SQ_SIZE/2))}


box = np.ones((square['y2']-square['y1'], square['x2']-square['x1'], 3)) * np.random.uniform(size=(3,))
horizontal_line = np.ones((HEIGHT, 10, 3)) * np.random.uniform(size=(3,))
vertical_line = np.ones((10, WIDTH, 3)) * np.random.uniform(size=(3,))

total = 0
left = 0
right = 0
none = 0
correct = 0 

while True:  # how many iterations. Eventually this would be a while True
    
    eegRaw = inlet.pull_sample()
    Channel_Data = str(eegRaw)
    Channel_Data = Channel_Data.replace("(", "")
    Channel_Data = Channel_Data.replace(")", "")
    Channel_Data = Channel_Data.replace("[", "")
    Channel_Data = Channel_Data.replace("]", "")
    Channel_Data = Channel_Data.split(", ")
    del Channel_Data[-1]
    Channel_Data = list(map(float, Channel_Data))
    Channel_Data = list(map(int, Channel_Data))
        
    #gets data into 16 channels (no idea why 17), need to np to make numbers?
    #need to round, set to 0 where <0
    #need to preprocess data in exact fashion as createModel.py
    Channel_Data = np.asarray(Channel_Data)
    Channel_Data = Channel_Data.astype(int)
    print("EEG Test State Numpy'd")


    env = np.zeros((WIDTH, HEIGHT, 3))

    env[:,HEIGHT//2-5:HEIGHT//2+5,:] = horizontal_line
    env[WIDTH//2-5:WIDTH//2+5,:,:] = vertical_line
    env[square['y1']:square['y2'], square['x1']:square['x2']] = box

    cv2.imshow('', env)
    cv2.waitKey(1)

    #Grab live input here
    print("instantiating network_input")
    network_input = np.array(Channel_Data).reshape(reshape)
    print("run input by model")
    out = model.predict(network_input)
    print("print guess")
    print(out[0])
    choice = np.argmax(out)
    # if choice == 0:
    #     if ACTION == "left":
    #         correct += 1
    #     square['x1'] -= MOVE_SPEED
    #     square['x2'] -= MOVE_SPEED
    #     left += 1

    # elif choice == 2:
    #     if ACTION == "right":
    #         correct += 1
    #     square['x1'] += MOVE_SPEED
    #     square['x2'] += MOVE_SPEED
    #     right += 1

    # else:
    #     if ACTION == "none":
    #         correct += 1
    #     none += 1

    # total += 1

print("done.")