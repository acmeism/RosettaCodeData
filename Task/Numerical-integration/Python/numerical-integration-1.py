from fractions import Fraction

def left_rect(f,x,h):
  return f(x)

def mid_rect(f,x,h):
  return f(x + h/2)

def right_rect(f,x,h):
  return f(x+h)

def trapezium(f,x,h):
  return (f(x) + f(x+h))/2.0

def simpson(f,x,h):
  return (f(x) + 4*f(x + h/2) + f(x+h))/6.0

def cube(x):
  return x*x*x

def reciprocal(x):
  return 1/x

def identity(x):
  return x

def integrate( f, a, b, steps, meth):
   h = (b-a)/steps
   ival = h * sum(meth(f, a+i*h, h) for i in range(steps))
   return ival

# Tests
for a, b, steps, func in ((0., 1., 100, cube), (1., 100., 1000, reciprocal)):
    for rule in (left_rect, mid_rect, right_rect, trapezium, simpson):
        print('%s integrated using %s\n  from %r to %r (%i steps) = %r' %
              (func.__name__, rule.__name__, a, b, steps,
               integrate( func, a, b, steps, rule)))
    a, b = Fraction.from_float(a), Fraction.from_float(b)
    for rule in (left_rect, mid_rect, right_rect, trapezium, simpson):
        print('%s integrated using %s\n  from %r to %r (%i steps and fractions) = %r' %
              (func.__name__, rule.__name__, a, b, steps,
               float(integrate( func, a, b, steps, rule))))

# Extra tests (compute intensive)
for a, b, steps, func in ((0., 5000., 5000000, identity),
                          (0., 6000., 6000000, identity)):
    for rule in (left_rect, mid_rect, right_rect, trapezium, simpson):
        print('%s integrated using %s\n  from %r to %r (%i steps) = %r' %
              (func.__name__, rule.__name__, a, b, steps,
               integrate( func, a, b, steps, rule)))
    a, b = Fraction.from_float(a), Fraction.from_float(b)
    for rule in (left_rect, mid_rect, right_rect, trapezium, simpson):
        print('%s integrated using %s\n  from %r to %r (%i steps and fractions) = %r' %
              (func.__name__, rule.__name__, a, b, steps,
               float(integrate( func, a, b, steps, rule))))
