"""

Based on https://pymotw.com/3/threading/

"""

import threading
import time
import random


def worker(workernum, barrier):
    # task 1
    sleeptime = random.random()
    print('Starting worker '+str(workernum)+" task 1, sleeptime="+str(sleeptime))
    time.sleep(sleeptime)
    print('Exiting worker'+str(workernum))
    barrier.wait()
    # task 2
    sleeptime = random.random()
    print('Starting worker '+str(workernum)+" task 2, sleeptime="+str(sleeptime))
    time.sleep(sleeptime)
    print('Exiting worker'+str(workernum))

barrier = threading.Barrier(3)

w1 = threading.Thread(target=worker, args=((1,barrier)))
w2 = threading.Thread(target=worker, args=((2,barrier)))
w3 = threading.Thread(target=worker, args=((3,barrier)))

w1.start()
w2.start()
w3.start()
