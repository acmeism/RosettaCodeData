# Python 3.0+ and 2.5+
try:
    from functools import reduce
except:
    pass


def mandelbrot(a): return reduce(lambda z, _: z*z + a, range(50), 0)
def step(start, step, iterations): return (start + (i * step) for i in range(iterations))

rows = (('*' if abs(mandelbrot(complex(x, y))) < 2 else ' '
        for x in step(-2.0, .0315, 80))
        for y in step(1, -.05, 41))

print( '\n'.join(''.join(row) for row in rows) )
