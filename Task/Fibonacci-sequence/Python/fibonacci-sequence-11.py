def fib():
    """Yield fib[n+1] + fib[n]"""
    yield 1  # have to start somewhere
    lhs, rhs = fib(), fib()
    yield next(lhs) # move lhs one iteration ahead
    while True:
        yield next(lhs)+next(rhs)

f=fib()
print [next(f) for _ in range(9)]
