from __future__ import print_function
import random
import gevent

delay = lambda: 1e-4*random.random()
gevent.joinall([gevent.spawn_later(delay(), print, line)
               for line in 'Enjoy Rosetta Code'.split()])
