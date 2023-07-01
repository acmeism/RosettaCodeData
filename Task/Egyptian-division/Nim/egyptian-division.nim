import strformat

func egyptianDivision(dividend, divisor: int): tuple[quotient, remainder: int] =
  if dividend < 0 or divisor <= 0:
    raise newException(IOError, "Invalid argument(s)")
  if dividend < divisor:
    return (0, dividend)

  var powersOfTwo: array[sizeof(int) * 8, int]
  var doublings: array[sizeof(int) * 8, int]

  for i, _ in powersOfTwo:
    powersOfTwo[i] = 1 shl i
    doublings[i] = divisor shl i
    if doublings[i] > dividend:
      break

  var answer = 0
  var accumulator = 0
  for i in countdown(len(doublings) - 1, 0):
    if accumulator + doublings[i] <= dividend:
      inc accumulator, doublings[i]
      inc answer, powersOfTwo[i]
      if accumulator == dividend:
        break
  (answer, dividend - accumulator)

let dividend = 580
let divisor = 34
var (quotient, remainder) = egyptianDivision(dividend, divisor)
echo fmt"{dividend} divided by {divisor} is {quotient} with remainder {remainder}"
