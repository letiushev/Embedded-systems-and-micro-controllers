The way to calculate ttc is the following:
  We have additional variables: velocity, prevS (previous measure of distance), current (current time), prevT(previous time) and ttc (time to collision)
  In the main loop, we set the current time = millis(). Then we calculate the velocity by negation of outputValue and prevS. The result we divide by time (current-prevT). The next step we calculate time to collision by the giving formula: −(outputValue/velocity)
  Then we have the “if” statement which depends of ttc value. If was less than 3 seconds (in my case 3 sec equals value of 150) we light the led, if not we put out the led.
  During implementation I had some phantom lightings of led which doesn’t affect significantly the result. Also on the video it was clearly seen that the bigger the velocity, the earlier led turns on.
