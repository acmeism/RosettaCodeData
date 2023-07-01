proc middleThreeDigits(i: int): string =
  var s = $abs(i)
  if s.len < 3 or s.len mod 2 == 0:
    raise newException(ValueError, "Need odd and >= 3 digits")
  let mid = s.len div 2
  return s[mid-1..mid+1]

const passing = @[123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345]
const failing = @[1, 2, -1, -10, 2002, -2002, 0]

for i in passing & failing:
  var answer = try: middleThreeDigits(i)
               except ValueError: getCurrentExceptionMsg()
  echo "middleThreeDigits(", i, ") returned: ", answer
