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
    

    print(Channel_Data)