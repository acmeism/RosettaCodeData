proc sumdigits(n, base: Natural): Natural =
  var n = n
  while n > 0:
    result += n mod base
    n = n div base

echo sumDigits(1, 10)
echo sumDigits(12345, 10)
echo sumDigits(123045, 10)
echo sumDigits(0xfe, 16)
echo sumDigits(0xf0e, 16)
