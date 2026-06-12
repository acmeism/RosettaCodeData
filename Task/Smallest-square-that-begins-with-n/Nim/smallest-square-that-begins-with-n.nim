import strutils

const Max = 49

func starts(k: int): (int, int) =
  ## Return the starting values of "k".
  ## The first one is less than Max.
  ## If the first one is in 1..9, the second one is 0 else it is in 1..9.
  var k = k
  while k > Max: k = k div 10
  result[0] = k
  if k < 10: return
  while k > 9: k = k div 10
  result[1] = k

var squares: array[1..Max, int]   # Maps "n" to the smallest square beginning with "n".
var count = Max                   # Number of squares still to found.
var n = 0

while count > 0:
  inc n
  let n2 = n * n
  let (s1, s2) = n2.starts()
  if squares[s1] == 0:
    squares[s1] = n2
    dec count
  if s2 != 0 and squares[s2] == 0:
    squares[s2] = n2
    dec count

for i, n2 in squares:
  stdout.write ($n2).align(5)
  stdout.write if i mod 7 == 0: '\n' else: ' '
