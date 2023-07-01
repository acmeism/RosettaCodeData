from itertools import islice, cycle

def fiblike(tail):
    for x in tail:
        yield x
    for i in cycle(xrange(len(tail))):
        tail[i] = x = sum(tail)
        yield x

fibo = fiblike([1, 1])
print list(islice(fibo, 10))
lucas = fiblike([2, 1])
print list(islice(lucas, 10))

suffixes = "fibo tribo tetra penta hexa hepta octo nona deca"
for n, name in zip(xrange(2, 11), suffixes.split()):
    fib = fiblike([1] + [2 ** i for i in xrange(n - 1)])
    items = list(islice(fib, 15))
    print "n=%2i, %5snacci -> %s ..." % (n, name, items)
