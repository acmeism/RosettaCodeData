#lang Python
import time

def main(bpm = 72, bpb = 4):
    sleep = 60.0 / bpm
    counter = 0
    while True:
        counter += 1
        if counter % bpb:
            print 'tick'
        else:
            print 'TICK'
        time.sleep(sleep)



main()
