def sumMul = { n, f -> BigInteger n1 = (n - 1) / f; f * n1 * (n1 + 1) / 2 }
def sum35 = { sumMul(it, 3) + sumMul(it, 5) - sumMul(it, 15) }
