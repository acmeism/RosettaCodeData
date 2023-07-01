function strtol(str, base)
{
  symbols = "0123456789abcdefghijklmnopqrstuvwxyz"
  res = 0
  str = tolower(str)
  for(i=1; i < length(str); i++) {
    res += index(symbols, substr(str, i, 1)) - 1
    res *= base
  }
  res += index(symbols, substr(str, length(str), 1)) - 1
  return res
}

function ltostr(num, base)
{
  symbols = "0123456789abcdefghijklmnopqrstuvwxyz"
  res = ""
  do {
    res = substr(symbols, num%base + 1, 1) res
    num = int(num/base)
  } while ( num != 0 )
  return res
}

BEGIN {
  print strtol("7b", 16)
  print ltostr(123, 16)
}
