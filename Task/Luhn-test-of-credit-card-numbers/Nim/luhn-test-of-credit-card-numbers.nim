proc luhn(cc: string): bool =
  const m = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
  var sum = 0
  var odd = true
  for i in countdown(cc.high, 0):
    let digit = ord(cc[i]) - ord('0')
    sum += (if odd: digit else: m[digit])
    odd = not odd
  result = sum mod 10 == 0

for cc in ["49927398716", "49927398717", "1234567812345678", "1234567812345670"]:
  echo cc, ' ', luhn(cc)
