import parseopt, strutils

var
  opt: OptParser = initOptParser()
  str = opt.cmdLineRest.split
  a: int = 0
  b: int = 0

try:
  a = parseInt(str[0])
  b = parseInt(str[1])
except ValueError:
  quit("Invalid params. Two integers are expected.")


echo("a      : " & $a)
echo("b      : " & $b)
echo("a + b  : " & $(a+b))
echo("a - b  : " & $(a-b))
echo("a * b  : " & $(a*b))
echo("a div b: " & $(a div b)) # div rounds towards zero
echo("a mod b: " & $(a mod b)) # sign(a mod b)==sign(a) if sign(a)!=sign(b)
echo("a ^ b  : " & $(a ^ b))
