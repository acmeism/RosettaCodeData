import time, signal

class WeAreDoneException(Exception):
    pass

def sigIntHandler(signum, frame):
    signal.signal(signal.SIGINT, signal.SIG_DFL) # resets to default handler
    raise WeAreDoneException

t1 = time.time()

try:
    signal.signal(signal.SIGINT, sigIntHandler)
    n = 0
    while True:
        time.sleep(0.5)
        n += 1
        print n
except WeAreDoneException:
    pass

tdelt = time.time() - t1
print 'Program has run for %5.3f seconds.' % tdelt
