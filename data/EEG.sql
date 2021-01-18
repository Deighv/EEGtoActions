CREATE DATABASE EEG;

DROP TABLE Headset_Data;
CREATE TABLE Headset_Data (
    Time_ID TIMESTAMP NOT NULL DEFAULT NOW(),
    Channel0 NUMERIC NOT NULL,
    Channel1 NUMERIC NOT NULL,
    Channel2 NUMERIC NOT NULL,
    Channel3 NUMERIC NOT NULL,
    Channel4 NUMERIC NOT NULL,
    Channel5 NUMERIC NOT NULL,
    Channel6 NUMERIC NOT NULL,
    Channel7 NUMERIC NOT NULL,
    Channel8 NUMERIC NOT NULL,
    Channel9 NUMERIC NOT NULL,
    Channel10 NUMERIC NOT NULL,
    Channel11 NUMERIC NOT NULL,
    Channel12 NUMERIC NOT NULL,
    Channel13 NUMERIC NOT NULL,
    Channel14 NUMERIC NOT NULL,
    Channel15 NUMERIC NOT NULL
);

/*CREATE TABLE Headset_Data (
    Time_ID TIMESTAMP NOT NULL DEFAULT NOW(),
    Channel0 NUMERIC NOT NULL,
    Channel1 NUMERIC NOT NULL,
    Channel2 NUMERIC NOT NULL,
    Channel3 NUMERIC NOT NULL,
    Channel4 NUMERIC NOT NULL,
    Channel5 NUMERIC NOT NULL,
    Channel6 NUMERIC NOT NULL,
    Channel7 NUMERIC NOT NULL,
    Channel8 NUMERIC NOT NULL,
    Channel9 NUMERIC NOT NULL,
    Channel10 NUMERIC NOT NULL,
    Channel11 NUMERIC NOT NULL,
    Channel12 NUMERIC NOT NULL,
    Channel13 NUMERIC NOT NULL,
    Channel14 NUMERIC NOT NULL,
    Channel15 NUMERIC NOT NULL,
    AccelChannel0 NUMERIC NOT NULL,
    AccelChannel1 NUMERIC NOT NULL,
    AccelChannel2 NUMERIC NOT NULL
);*/

DROP TABLE Controller_Data;
CREATE TABLE Controller_Data (
    Time_ID TIMESTAMP NOT NULL DEFAULT NOW(),
    Stick_L_X NUMERIC NOT NULL,
    Stick_L_Y NUMERIC NOT NULL,
    Stick_R_X NUMERIC NOT NULL,
    Stick_R_Y NUMERIC NOT NULL,
    Stick_L_Click boolean NOT NULL,
    Stick_R_Click boolean NOT NULL,
    Dpad_Right boolean NOT NULL,
    Dpad_Left boolean NOT NULL,
    Dpad_Up boolean NOT NULL,
    Dpad_Down boolean NOT NULL,
    Start_Button boolean NOT NULL,
    Select_Button boolean NOT NULL,
    X boolean NOT NULL,
    A boolean NOT NULL,
    B boolean NOT NULL,
    Y boolean NOT NULL,
    Bumper_L boolean NOT NULL,
    Bumper_R boolean NOT NULL,
    Trigger_L NUMERIC NOT NULL,
    Trigger_R NUMERIC NOT NULL
);
DROP TABLE Headset_Data;
CREATE TABLE Headset_Data (
    Time_ID TIMESTAMP NOT NULL DEFAULT NOW(),
    Channel0 NUMERIC NOT NULL,
    Channel1 NUMERIC NOT NULL,
    Channel2 NUMERIC NOT NULL,
    Channel3 NUMERIC NOT NULL,
    Channel4 NUMERIC NOT NULL,
    Channel5 NUMERIC NOT NULL,
    Channel6 NUMERIC NOT NULL,
    Channel7 NUMERIC NOT NULL,
    Channel8 NUMERIC NOT NULL,
    Channel9 NUMERIC NOT NULL,
    Channel10 NUMERIC NOT NULL,
    Channel11 NUMERIC NOT NULL,
    Channel12 NUMERIC NOT NULL,
    Channel13 NUMERIC NOT NULL,
    Channel14 NUMERIC NOT NULL,
    Channel15 NUMERIC NOT NULL
);
/* Controller press index- ML wants to match to a single numeric identifier, with just dpad and xaby there's only 64 total options
 */

DROP VIEW Controller_Data_Normalized_View;
CREATE VIEW Controller_Data_Normalized_View AS
SELECT 
    CASE WHEN stick_l_x >= 0.1 THEN true ELSE false END dpad_right,
    CASE WHEN stick_l_x <= -0.1 THEN true ELSE false END dpad_left,
    CASE WHEN stick_l_y >= 0.1 THEN true ELSE false END dpad_up,
    CASE WHEN stick_l_y <= -0.1 THEN true ELSE false END dpad_down,
    x,a,b,y,Time_ID
FROM Controller_Data
ORDER BY Controller_Data.Time_ID ASC;



DROP TABLE Controller_Press_Index;
CREATE TABLE Controller_Press_Index (
    Controller_Press_Index_ID serial PRIMARY KEY,
    Dpad_Right boolean NOT NULL,
    Dpad_Left boolean NOT NULL,
    Dpad_Up boolean NOT NULL,
    Dpad_Down boolean NOT NULL,
    X boolean NOT NULL,
    A boolean NOT NULL,
    B boolean NOT NULL,
    Y boolean NOT NULL
);

/* sorrrrrrrry maaaaark */
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,FALSE,TRUE,FALSE,TRUE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (TRUE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE);
INSERT INTO public.controller_press_index(dpad_left, dpad_right, dpad_up, dpad_down, a, x, b, y)	VALUES (FALSE,TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE);


EEGSql = """
SELECT  
SUM(GREATEST(channel0, 0)) / 70000,
SUM(GREATEST(channel1, 0)) / 70000,
SUM(GREATEST(channel2, 0)) / 70000,
SUM(GREATEST(channel3, 0)) / 70000,
SUM(GREATEST(channel4, 0)) / 70000,
SUM(GREATEST(channel5, 0)) / 70000,
SUM(GREATEST(channel6, 0)) / 70000,
SUM(GREATEST(channel7, 0)) / 70000,
SUM(GREATEST(channel8, 0)) / 70000,
SUM(GREATEST(channel9, 0)) / 70000,
SUM(GREATEST(channel10, 0)) / 70000,
SUM(GREATEST(channel11, 0)) / 70000,
SUM(GREATEST(channel12, 0)) / 70000,
SUM(GREATEST(channel13, 0)) / 70000,
SUM(GREATEST(channel14, 0)) / 70000,
SUM(GREATEST(channel15, 0)) / 70000
  FROM headset_data 
GROUP BY Time_ID 
ORDER BY Time_ID ASC
LIMIT 1000;
"""