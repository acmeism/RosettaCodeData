from algorithm import reverse

const Table = [[0, 3, 1, 7, 5, 9, 8, 6, 4, 2],
               [7, 0, 9, 2, 1, 5, 4, 8, 6, 3],
               [4, 2, 0, 6, 8, 7, 1, 3, 5, 9],
               [1, 7, 5, 0, 9, 8, 3, 4, 2, 6],
               [6, 1, 2, 3, 0, 4, 5, 9, 7, 8],
               [3, 6, 7, 4, 2, 0, 9, 5, 8, 1],
               [5, 8, 6, 9, 7, 2, 0, 1, 3, 4],
               [8, 9, 4, 5, 3, 6, 2, 0, 1, 7],
               [9, 4, 3, 8, 6, 1, 7, 2, 0, 5],
               [2, 5, 8, 1, 4, 3, 6, 7, 9, 0]]

type Digit = range[0..9]

func isValid(digits: openArray[Digit]): bool =
  ## Apply Damm algorithm to check validity of a digit sequence.
  var interim = 0
  for d in digits:
    interim = Table[interim][d]
  result = interim == 0

proc toDigits(n: int): seq[Digit] =
  ## Return the digits of a number.
  var n = n
  while true:
    result.add(n mod 10)
    n = n div 10
    if n == 0:
      break
  result.reverse()

proc checkData(digits: openArray[Digit]) =
  ## Check if a digit sequence if valid.
  if isValid(digits):
    echo "Sequence ", digits, " is valid."
  else:
    echo "Sequence ", digits, " is invalid."

checkData(5724.toDigits)
checkData(5727.toDigits)
checkData([Digit 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 6, 7, 8, 9, 0, 1])
checkData([Digit 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 6, 7, 8, 9, 0, 8])
