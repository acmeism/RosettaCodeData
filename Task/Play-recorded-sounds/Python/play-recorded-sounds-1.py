import time
from pygame import mixer

mixer.init(frequency=16000) #set frequency for wav file
s1 = mixer.Sound('test.wav')
s2 = mixer.Sound('test2.wav')

#individual
s1.play(-1)         #loops indefinitely
time.sleep(0.5)

#simultaneously
s2.play()          #play once
time.sleep(2)
s2.play(2)         #optional parameter loops three times
time.sleep(10)

#set volume down
s1.set_volume(0.1)
time.sleep(5)

#set volume up
s1.set_volume(1)
time.sleep(5)

s1.stop()
s2.stop()
mixer.quit()
