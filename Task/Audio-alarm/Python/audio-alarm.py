import time
import os

seconds = input("Enter a number of seconds: ")
sound = input("Enter an mp3 filename: ")

time.sleep(float(seconds))
os.startfile(sound + ".mp3")
