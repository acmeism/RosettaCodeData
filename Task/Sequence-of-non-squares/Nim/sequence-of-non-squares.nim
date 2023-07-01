import math, strutils

func nosqr(n: int): seq[int] =
  result = newSeq[int](n)
  for i in 1..n:
    result[i - 1] = i + i.float.sqrt.toInt

func issqr(n: int): bool =
  sqrt(float(n)).splitDecimal().floatpart < 1e-7


echo "Sequence for n = 22:"
echo nosqr(22).join(" ")

for i in nosqr(1_000_000 - 1):
  assert not issqr(i)
echo "\nNo squares were found for n less than 1_000_000."
