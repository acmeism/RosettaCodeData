>>> from math import sqrt
>>> def sd(x):
    sd.sum  += x
    sd.sum2 += x*x
    sd.n    += 1.0
    sum, sum2, n = sd.sum, sd.sum2, sd.n
    return sqrt(sum2/n - sum*sum/n/n)

>>> sd.sum = sd.sum2 = sd.n = 0
>>> for value in (2,4,4,4,5,5,7,9):
    print (value, sd(value))


(2, 0.0)
(4, 1.0)
(4, 0.94280904158206258)
(4, 0.8660254037844386)
(5, 0.97979589711327075)
(5, 1.0)
(7, 1.3997084244475311)
(9, 2.0)
>>>
