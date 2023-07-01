def fib(n):
    from functools import reduce
    return reduce(lambda x, y: (x[1], x[0] + x[1]), range(n), (0, 1))[0]
