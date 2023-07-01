from itertools import islice

def fib():
    yield 0
    yield 1
    a, b = fib(), fib()
    next(b)
    while True:
        yield next(a)+next(b)

print(tuple(islice(fib(), 10)))
