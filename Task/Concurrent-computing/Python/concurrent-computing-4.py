import threading
import random

def echo(text):
    print(text)

for text in ["Enjoy", "Rosetta", "Code"]:
    threading.Timer(random.random(), echo, (text,)).start()
