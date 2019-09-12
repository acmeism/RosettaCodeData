import threading
import random

def echo(text):
    print(text)

threading.Timer(random.random(), echo, ("Enjoy",)).start()
threading.Timer(random.random(), echo, ("Rosetta",)).start()
threading.Timer(random.random(), echo, ("Code",)).start()
