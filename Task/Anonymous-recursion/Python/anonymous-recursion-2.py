>>>from functools import partial
>>> Y = lambda f: (lambda x: x(x))(lambda y: partial(f, lambda *args: y(y)(*args)))
>>> fib = lambda f, n: None if n < 0 else (0 if n == 0 else (1 if n == 1 else f(n-1) + f(n-2)))
>>> [ Y(fib)(i) for i in range(-2, 10) ]
[None, None, 0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
