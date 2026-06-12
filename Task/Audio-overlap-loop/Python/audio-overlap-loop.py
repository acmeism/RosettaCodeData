import sys
import time
from threading import Thread

from playsound import playsound

FILE = "loop.wav"


def play(count: int, delay=0):
    for i in range(count):
        t = Thread(target=playsound, args=(FILE,))
        t.start()
        time.sleep(delay)

    t.join()


def main():
    if len(sys.argv) < 3:
        print("Missing arguments", file=sys.stderr)
        exit(1)

    repeat = int(sys.argv[1])
    delay = int(sys.argv[2])

    play(repeat, delay)


if __name__ == "__main__":
    main()
