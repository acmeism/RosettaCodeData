from random import randint

class Found20(Exception):
    pass

mat = [[randint(1, 20) for x in xrange(10)] for y in xrange(10)]

try:
    for row in mat:
        for item in row:
            print item,
            if item == 20:
                raise Found20
        print
except Found20:
    print
