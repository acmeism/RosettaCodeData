import time

def counter():
    n = 0
    t1 = time.time()
    while True:
        try:
            time.sleep(0.5)
            n += 1
            print n
        except KeyboardInterrupt, e:
            print 'Program has run for %5.3f seconds.' % (time.time() - t1)
            break

counter()
