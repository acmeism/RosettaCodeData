>>> import fractions
>>> def lcm(a,b): return abs(a * b) / fractions.gcd(a,b) if a and b else 0

>>> lcm(12, 18)
36
>>> lcm(-6, 14)
42
>>> assert lcm(0, 2) == lcm(2, 0) == 0
>>>
