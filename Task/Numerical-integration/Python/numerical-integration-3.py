def faster_simpson(f, a, b, steps):
   h = (b-a)/steps
   a1 = a+h/2
   s1 = sum( f(a1+i*h) for i in range(0,steps))
   s2 = sum( f(a+i*h) for i in range(1,steps))
   return (h/6.0)*(f(a)+f(b)+4.0*s1+2.0*s2)
