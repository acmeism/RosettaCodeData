import random
from twisted.internet    import reactor, task, defer
from twisted.python.util import println

delay = lambda: 1e-4*random.random()
d = defer.DeferredList([task.deferLater(reactor, delay(), println, line)
                        for line in 'Enjoy Rosetta Code'.split()])
d.addBoth(lambda _: reactor.stop())
reactor.run()
