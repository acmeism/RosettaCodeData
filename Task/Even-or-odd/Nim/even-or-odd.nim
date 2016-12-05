# Least signficant bit:
proc isOdd(i: int): bool = (i and 1) != 0
proc isEven(i: int): bool = (i and 1) == 0

# Modulo:
proc isOdd2(i: int): bool = (i mod 2) != 0
proc isEven2(i: int): bool = (i mod 2) == 0

# Bit Shifting:
proc isOdd3(n: int): bool = n != ((n shr 1) shl 1)
proc isEven3(n: int): bool = n == ((n shr 1) shl 1)

echo isEven(1)
echo isOdd2(5)
