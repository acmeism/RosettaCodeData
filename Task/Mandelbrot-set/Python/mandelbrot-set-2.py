import math
mandelbrot = lambda z , c , n = 40 : float('nan') if abs(z) > 1000 else mandelbrot(z**2+c,c,n-1) if n > 0 else z**2+c
print("\n".join(["".join(["#" if not math.isnan(mandelbrot(0,x+1j*y).real) else " "
                 for x in [a*0.02 for a in xrange(-80,30)]])
                 for y in [a*0.05 for a in xrange(-20,20)]])
     )
