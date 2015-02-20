import math

def mandelbrot(z , c , n=40):
    if abs(z) > 1000:
        return float("nan")
    else:
        if n > 0:
            return mandelbrot(z ** 2 + c, c, n - 1)
        else:
            return z ** 2 + c

print("\n".join(["".join(["#" if not math.isnan(mandelbrot(0, x + 1j * y).real) else " "
                 for x in [a * 0.02 for a in range(-80, 30)]])
                 for y in [a * 0.05 for a in range(-20, 20)]])
     )
