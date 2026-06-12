from strutils import align, parseInt

#[
  Nim lets you define custom operators using any combination of these symbols:

  = + - * / < > @ $ ~ & % | ! ? ^ . : \

  We'll use +@ for lunar addition and *@ for lunar multiplication.
]#
proc `+@`(lhs, rhs: Natural): Natural =
  var
    maxDigits = max(($lhs).len, ($rhs).len)
    answer, left, right: string
  answer = "".align(maxDigits, '0')
  left = ($lhs).align(maxDigits, '0')
  right = ($rhs).align(maxDigits, '0')

  for digit in 0..<answer.len:
    answer[digit] = char(max(ord(left[digit]), ord(right[digit])))

  result = answer.parseInt

proc `*@`(lhs, rhs: Natural): Natural =
  var
    maxDigits = ($lhs).len + ($rhs).len - 1
    answer, left, right: string
    products: seq[Natural]
  answer = "".align(maxDigits, '0')
  left = $lhs
  right = $rhs

  for rdigit in 1..right.len:
    var product: string
    for ldigit in 0..<left.len:
      product &= char(min(ord(left[ldigit]), ord(right[^rdigit])))
    for i in 1..rdigit - 1:
      product &= '0'
    products &= product.parseInt
  for product in products:
    result = result +@ product

proc lunar_fact(n: Natural): Natural =
  if n <= 1:
    return 1
  else:
    result = 1
    for i in 2..n:
      result = result *@ i

var evenNumbers, squares, factorials: seq[Natural]

block:
  var n = 0
  while evenNumbers.len < 20:
    if n *@ 2 notin evenNumbers:
      evenNumbers &= n *@ 2
    n += 1

for n in 0..<20:
  squares &= n *@ n
  factorials &= lunar_fact(n)

var testSquare = 1
while testSquare *@ testSquare > (testSquare - 1) *@ (testSquare - 1):
  testSquare += 1

echo "Addition: 976 +@ 348 == ", 976 +@ 348
echo "Multiplication: 976 *@ 348 == ", 976 *@ 348
echo ""
echo "Addition: 23 +@ 321 == ", 23 +@ 321
echo "Multiplication: 23 *@ 321 == ", 23 *@ 321
echo ""
echo "Addition: 232 +@ 35 == ", 232 +@ 35
echo "Multiplication: 232 *@ 35 == ", 232 *@ 35
echo ""
echo "Addition: 123 +@ 32192 +@ 415 +@ 8 == ", 123 +@ 32192 +@ 415 +@ 8
echo "Multiplication: 123 *@ 32192 *@ 415 *@ 8 == ", 123 *@ 32192 *@ 415 *@ 8
echo ""

echo "First twenty distinct even numbers: "
echo evenNumbers, "\n"
echo "First twenty squares: "
echo squares, "\n"
echo "First twenty factorials: "
echo factorials, "\n"
echo testSquare, " is the first lunar square smaller than the previous."

