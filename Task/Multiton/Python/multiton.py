#!/usr/bin/python

import threading

class Multiton:
    def __init__(self, registry, refnum, data=None):
        with registry.lock:
            if 0 < refnum <= registry.max_instances and registry.instances[refnum] is None:
                self.data = data
                registry.instances[refnum] = self
            elif data is None and 0 < refnum <= registry.max_instances and isinstance(registry.instances[refnum], Multiton):
                self.data = registry.instances[refnum].data
            else:
                raise Exception("Cannot create or find instance with instance reference number {}".format(refnum))

class Registry:
    def __init__(self, maxnum):
        self.lock = threading.Lock()
        self.max_instances = maxnum
        self.instances = [None] * maxnum

reg = Registry(3)
m0 = Multiton(reg, 1, "zero")
m1 = Multiton(reg, 2, 1.0)
m2 = Multiton(reg, 1)
m3 = Multiton(reg, 2)

for m in [m0, m1, m2, m3]:
   print("Multiton is {}".format(m.data))


# produce error
#m2 = Multiton(reg, 3, [2])

# produce error
# m3 = Multiton(reg, 4, "three")

# produce error
# m5 = Multiton(reg, 5)
