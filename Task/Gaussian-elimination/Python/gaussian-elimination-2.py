$ python3
Python 3.6.0 |Anaconda custom (64-bit)| (default, Dec 23 2016, 12:22:00)
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> # https://docs.scipy.org/doc/numpy/reference/generated/numpy.linalg.solve.html
>>> import numpy.linalg
>>> a = [[2, 9, 4], [7, 5, 3], [6, 1, 8]]
>>> b = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
>>> numpy.linalg.solve(a,b)
array([[-0.10277778,  0.18888889, -0.01944444],
       [ 0.10555556,  0.02222222, -0.06111111],
       [ 0.06388889, -0.14444444,  0.14722222]])
>>>
