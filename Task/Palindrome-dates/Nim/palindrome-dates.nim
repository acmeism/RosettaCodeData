import strformat, times

func digits(n: int): seq[int] =
  var n = n
  while n != 0:
    result.add n mod 10
    n = n div 10

echo "First 15 palindrome dates after 2020-02-02:"
var count = 0
var year = 2021
while count != 15:
  let d = year.digits
  let monthNum = 10 * d[0] + d[1]
  let dayNum = 10 * d[2] + d[3]
  if monthNum in 1..12:
    if dayNum <= getDaysInMonth(Month(monthNum), year):
      # Date is valid.
      echo &"{year}-{monthNum:02}-{dayNum:02}"
      inc count
  inc year
