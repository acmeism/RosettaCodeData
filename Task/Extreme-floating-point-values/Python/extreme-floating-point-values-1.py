>>> # Extreme values from expressions
>>> inf = 1e234 * 1e234
>>> _inf = 1e234 * -1e234
>>> _zero = 1 / _inf
>>> nan = inf + _inf
>>> inf, _inf, _zero, nan
(inf, -inf, -0.0, nan)
>>> # Print
>>> for value in (inf, _inf, _zero, nan): print (value)

inf
-inf
-0.0
nan
>>> # Extreme values from other means
>>> float('nan')
nan
>>> float('inf')
inf
>>> float('-inf')
-inf
>>> -0.
-0.0
>>> # Some arithmetic
>>> nan == nan
False
>>> nan is nan
True
>>> 0. == -0.
True
>>> 0. is -0.
False
>>> inf + _inf
nan
>>> 0.0 * nan
nan
>>> nan * 0.0
nan
>>> 0.0 * inf
nan
>>> inf * 0.0
nan
