from functools import reduce

def mandelbrot(x, y, c): return ' *'[abs(reduce(lambda z, _: z*z + c, range(99), 0)) < 2]

print('\n'.join(''.join(mandelbrot(x, y, x/50 + y/50j) for x in range(-100, 25)) for y in range(-50, 50)))
