>>> from statistics import mean
>>> mean([1e20,-1e-20,3,1,4,1,5,9,-1e20,1e-20])
2.3
>>> mean([10**10000, -10**10000, 3, 1, 4, 1, 5, 9, 0, 0])
2.3
>>> mean([10**10000, -10**10000, 3, 1, 4, 1, 5, 9, Fraction(1, 10**10000), Fraction(-1, 10**10000)])
Fraction(23, 10)
>>> big = 10**10000
>>> mean([Decimal(big), Decimal(-big), 3, 1, 4, 1, 5, 9, 1/Decimal(big), -1/Decimal(big)])
Decimal('2.3')
