import time
from pygame import mixer
from pygame.mixer import music

mixer.init()
music.load('test.mp3')

music.play()
time.sleep(10)

music.stop()
mixer.quit()
