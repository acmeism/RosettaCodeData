>>> def isint(f):
    return complex(f).imag == 0 and complex(f).real.is_integer()

>>> [isint(f) for f in (1.0, 2, (3.0+0.0j), 4.1, (3+4j), (5.6+0j))]
[True, True, True, False, False, False]

>>> # Test cases
...
>>> isint(25.000000)
True
>>> isint(24.999999)
False
>>> isint(25.000100)
False
>>> isint(-2.1e120)
True
>>> isint(-5e-2)
False
>>> isint(float('nan'))
False
>>> isint(float('inf'))
False
>>> isint(5.0+0.0j)
True
>>> isint(5-5j)
False
