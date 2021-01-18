
SELECT (avg(hd.channel0) + avg(hd.channel1) + avg(hd.channel2) + avg(hd.channel3) + avg(channel4) + avg(hd.channel5) + avg(hd.channel6) + avg(hd.channel7) + avg(hd.channel8) + avg(hd.channel9) + avg(hd.channel10) + avg(hd.channel11) + avg(hd.channel12) + avg(hd.channel3) + avg(hd.channel14) + avg(hd.channel5))/16
FROM public.headset_data hd
  INNER JOIN public.Controller_data cd
  ON hd.Time_ID = cd.Time_ID
 WHERE cd.x = true
  
SELECT (avg(hd.channel0) + avg(hd.channel1) + avg(hd.channel2) + avg(hd.channel3) + avg(channel4) + avg(hd.channel5) + avg(hd.channel6) + avg(hd.channel7) + avg(hd.channel8) + avg(hd.channel9) + avg(hd.channel10) + avg(hd.channel11) + avg(hd.channel12) + avg(hd.channel3) + avg(hd.channel14) + avg(hd.channel5))/16
FROM public.headset_data hd
  INNER JOIN public.Controller_data cd
  ON hd.Time_ID = cd.Time_ID
 WHERE cd.y = true
