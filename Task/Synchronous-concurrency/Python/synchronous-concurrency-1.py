import sys
from Queue import Queue
from threading import Thread

lines = Queue(1)
count = Queue(1)

def read(file):
    try:
        for line in file:
            lines.put(line)
    finally:
        lines.put(None)
    print count.get()

def write(file):
    n = 0
    while 1:
        line = lines.get()
        if line is None:
            break
        file.write(line)
        n += 1
    count.put(n)

reader = Thread(target=read, args=(open('input.txt'),))
writer = Thread(target=write, args=(sys.stdout,))
reader.start()
writer.start()
reader.join()
writer.join()
