import random, sys, time
import threading

lock = threading.Lock()

def echo(s):
    time.sleep(1e-2*random.random())
    # use `.write()` with lock due to `print` prints empty lines occasionally
    with lock:
        sys.stdout.write(s)
        sys.stdout.write('\n')

for line in 'Enjoy Rosetta Code'.split():
    threading.Thread(target=echo, args=(line,)).start()
