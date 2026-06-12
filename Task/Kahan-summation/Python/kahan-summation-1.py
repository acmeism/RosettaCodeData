>>> from decimal import *
>>>
>>> getcontext().prec = 6
>>>
>>> def kahansum(input):
    summ = c = 0
    for num in input:
        y = num - c
        t = summ + y
        c = (t - summ) - y
        summ = t
    return summ

>>> a, b, c = [Decimal(n) for n in '10000.0 3.14159 2.71828'.split()]
>>> a, b, c
(Decimal('10000.0'), Decimal('3.14159'), Decimal('2.71828'))
>>>
>>> (a + b) + c
Decimal('10005.8')
>>> kahansum([a, b, c])
Decimal('10005.9')
>>>
>>>
>>> sum([a, b, c])
Decimal('10005.8')
>>> # it seems Python's sum() doesn't make use of this technique.
>>>
>>> # More info on the current Decimal context:
>>> getcontext()
Context(prec=6, rounding=ROUND_HALF_EVEN, Emin=-999999, Emax=999999, capitals=1, clamp=0, flags=[Inexact, Rounded], traps=[InvalidOperation, DivisionByZero, Overflow])
>>>
>>>
>>> ## Lets try the simple summation with more precision for comparison
>>> getcontext().prec = 20
>>> (a + b) + c
Decimal('10005.85987')
>>>
