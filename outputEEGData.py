from datetime import datetime
from pylsl import StreamInlet, resolve_stream
#from inputs import get_gamepad
import psycopg2
import XInput
#This Grabs data from the EEG/LSL from open BCI and inserts a line to a DB for every entry, previously grabbed accelerometer data as well, was dropped for simplicity
print("Connecting to Database")
con = psycopg2.connect(database="eeg", user="postgres", password="password", host="127.0.0.1", port="5432")
print(con)
cur = con.cursor() 
#Connecting: cyton, 16ch, 60hz,com 3
print("Finding Data Streams")
streams = resolve_stream('type', 'EEG')
#accStream = StreamInlet(streams[0]) #Accelerometer
eegStream = StreamInlet(streams[0]) #timeseries 
print("Streams Resolved")
print("Recording Headset+Controller data")
while True:
    eegRaw = eegStream.pull_sample()
    Channel_Data = str(eegRaw)
    Channel_Data = Channel_Data.replace("(", "")
    Channel_Data = Channel_Data.replace(")", "")
    Channel_Data = Channel_Data.replace("[", "")
    Channel_Data = Channel_Data.replace("]", "")
    Channel_Data = Channel_Data.split(", ")
    #accelerometerRaw = accStream.pull_sample()
    #Accelerometer_Data = str(accelerometerRaw)
    #Accelerometer_Data = Accelerometer_Data.replace("(", "")
    #Accelerometer_Data = Accelerometer_Data.replace(")", "")
    #Accelerometer_Data = Accelerometer_Data.replace("[", "")
    #Accelerometer_Data = Accelerometer_Data.replace("]", "")
    #Accelerometer_Data = Accelerometer_Data.split(", ")
    Button_Presses = XInput.get_button_values(XInput.get_state(0))
    #example data {'DPAD_UP': False (1), 'DPAD_DOWN': False(3), 'DPAD_LEFT': False (5), 'DPAD_RIGHT': False (7), 'START': False(9), 'BACK': False(11), 'LEFT_THUMB': False(13), 'RIGHT_THUMB': False(15), 'LEFT_SHOULDER': False (17), 'RIGHT_SHOULDER': False (19), 'A': False (21), 'B': False (23), 'X': False (25), 'Y': False (27)}
    Trigger_Presses = XInput.get_trigger_values(XInput.get_state(0))
    #(0, 0) to (255,255)
    Thumb_Values = XInput.get_thumb_values(XInput.get_state(0))
    #((0.0, -0.0), (0.0, -0.0)) -32667 to 32666
    #cur.execute("INSERT INTO Headset_Data(Channel0,Channel1,Channel2,Channel3,Channel4,Channel5,Channel6,Channel7,Channel8,Channel9,Channel10,Channel11,Channel12,Channel13,Channel14,Channel15,AccelChannel0,AccelChannel1,AccelChannel2) VALUES (" + Channel_Data[0] + "," + Channel_Data[1] + "," + Channel_Data[2] + "," + Channel_Data[3] + "," + Channel_Data[4] + "," + Channel_Data[5] + "," + Channel_Data[6] + "," + Channel_Data[7] + "," + Channel_Data[8] + "," + Channel_Data[9] + "," + Channel_Data[10] + "," + Channel_Data[11] + "," + Channel_Data[12] + "," + Channel_Data[13] + "," + Channel_Data[14] + "," + Channel_Data[15] + ","  + Accelerometer_Data[0] + "," + Accelerometer_Data[1] + "," + Accelerometer_Data[2] + ");")
    cur.execute("""
        INSERT INTO Headset_Data(
            Channel0,
            Channel1,
            Channel2,
            Channel3,
            Channel4,
            Channel5,
            Channel6,
            Channel7,
            Channel8,
            Channel9,
            Channel10,
            Channel11,
            Channel12,
            Channel13, 
            Channel14,
            Channel15
        ) VALUES (
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s)
        """,
        (
        Channel_Data[0],
        Channel_Data[1],
        Channel_Data[2],
        Channel_Data[3],
        Channel_Data[4],
        Channel_Data[5],
        Channel_Data[6],
        Channel_Data[7],
        Channel_Data[8],
        Channel_Data[9],
        Channel_Data[10],
        Channel_Data[11],
        Channel_Data[12],
        Channel_Data[13],
        Channel_Data[14],
        Channel_Data[15]
        )
    )
    cur.execute("""
        INSERT INTO Controller_Data(
            stick_l_x,
            stick_l_y,
            stick_r_x,
            stick_r_y,
            stick_l_click,
            stick_r_click,
            dpad_right,
            dpad_left,
            dpad_up,
            dpad_down,
            start_button,
            select_button,
            x,
            a,
            b,
            y,
            bumper_l,
            bumper_r,
            trigger_l,
            trigger_r
        ) VALUES (
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s)
        """,
        (
        Thumb_Values[0][0],
        Thumb_Values[0][1],
        Thumb_Values[1][0],
        Thumb_Values[1][1],
        Button_Presses["LEFT_THUMB"],
        Button_Presses["RIGHT_THUMB"],
        Button_Presses["DPAD_RIGHT"],
        Button_Presses["DPAD_LEFT"],
        Button_Presses["DPAD_UP"],
        Button_Presses["DPAD_DOWN"],
        Button_Presses["START"],
        Button_Presses["BACK"],
        Button_Presses["X"],
        Button_Presses["A"],
        Button_Presses["B"],
        Button_Presses["Y"],
        Button_Presses["LEFT_SHOULDER"],
        Button_Presses["RIGHT_SHOULDER"],
        Trigger_Presses[0],
        Trigger_Presses[1]
        )
    )
    con.commit()
con.close()
