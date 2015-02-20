import signal, time, threading
done = False
n = 0

def counter():
   global n, timer
   n += 1
   print n
   timer = threading.Timer(0.5, counter)
   timer.start()

def sigIntHandler(signum, frame):
   global done
   timer.cancel()
   done = True

def intrptUNIX():
   global timer
   signal.signal(signal.SIGINT, sigIntHandler)

   timer = threading.Timer(0.5, counter)
   timer.start()
   while not done:
      signal.pause()

t1 = time.time()
intrptUNIX()
tdelt = time.time() - t1
print 'Program has run for %5.3f seconds.' % tdelt
