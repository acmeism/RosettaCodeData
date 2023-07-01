from fractions import Fraction

for candidate in range(2, 2**19):
  sum = Fraction(1, candidate)
  for factor in range(2, int(candidate**0.5)+1):
    if candidate % factor == 0:
      sum += Fraction(1, factor) + Fraction(1, candidate // factor)
  if sum.denominator == 1:
    print("Sum of recipr. factors of %d = %d exactly %s" %
           (candidate, int(sum), "perfect!" if sum == 1 else ""))
