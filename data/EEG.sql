--Must create DB in separate script/gui:
--CREATE DATABASE EEG;

-- Table: public.headset_data

-- DROP TABLE public.headset_data;

CREATE TABLE public.headset_data
(
    time_id timestamp without time zone NOT NULL DEFAULT now(),
    channel0 numeric NOT NULL,
    channel1 numeric NOT NULL,
    channel2 numeric NOT NULL,
    channel3 numeric NOT NULL,
    channel4 numeric NOT NULL,
    channel5 numeric NOT NULL,
    channel6 numeric NOT NULL,
    channel7 numeric NOT NULL,
    channel8 numeric NOT NULL,
    channel9 numeric NOT NULL,
    channel10 numeric NOT NULL,
    channel11 numeric NOT NULL,
    channel12 numeric NOT NULL,
    channel13 numeric NOT NULL,
    channel14 numeric NOT NULL,
    channel15 numeric NOT NULL,
    primary_key integer NOT NULL DEFAULT nextval('headset_data_primary_key_seq'::regclass),
    CONSTRAINT headset_data_pkey PRIMARY KEY (primary_key)
)

TABLESPACE pg_default;

ALTER TABLE public.headset_data
    OWNER to postgres;

DROP TABLE IF EXISTS Controller_Data CASCADE;
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
DROP TABLE IF EXISTS Headset_Data CASCADE;
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
/* Controller press index- ML wants to match to a single numeric identifier, with just dpad and 4 buttons (X,A,B,Y) there's only 64 total options
 */
DROP TABLE IF EXISTS Controller_Press_Index CASCADE;
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

-- View: public.controller_data_normalized_view

-- DROP VIEW public.controller_data_normalized_view;

CREATE OR REPLACE VIEW public.controller_data_normalized_view
 AS
 SELECT
        CASE
            WHEN (controller_data.stick_l_x >= 0.5) THEN true
            ELSE false
        END AS dpad_right,
        CASE
            WHEN (controller_data.stick_l_x <= -0.5) THEN true
            ELSE false
        END AS dpad_left,
        CASE
            WHEN (controller_data.stick_l_y >= 0.5) THEN true
            ELSE false
        END AS dpad_up,
        CASE
            WHEN (controller_data.stick_l_y <= -0.5) THEN true
            ELSE false
        END AS dpad_down,
    controller_data.x,
    controller_data.a,
    controller_data.b,
    controller_data.y,
    controller_data.time_id,
	(ROW_NUMBER() OVER (ORDER BY Time_ID ASC)) as Row_Index
   FROM controller_data
  ORDER BY controller_data.time_id;

ALTER TABLE public.controller_data_normalized_view
    OWNER TO postgres;




/* everyone loves data in their repo! */
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