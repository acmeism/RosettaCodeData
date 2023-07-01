from random import randint

def do_scan(mat):
    for row in mat:
        for item in row:
            print item,
            if item == 20:
                print
                return
        print
    print

mat = [[randint(1, 20) for x in xrange(10)] for y in xrange(10)]
do_scan(mat)
