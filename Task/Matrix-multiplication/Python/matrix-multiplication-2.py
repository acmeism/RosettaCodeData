from operator import mul

def matrixMul(m1, m2):
  return map(
    lambda row:
      map(
        lambda *column:
          sum(map(mul, row, column)),
        *m2),
    m1)
