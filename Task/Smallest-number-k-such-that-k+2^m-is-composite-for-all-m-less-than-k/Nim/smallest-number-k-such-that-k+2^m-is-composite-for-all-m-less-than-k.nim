import integers

let One = newInteger(1)

proc a(k: Positive): bool =
  ## Return true if "k" is a sequence member, false otherwise.
  if k == 1: return false
  for m in 1..<k:
    if isPrime(One shl m + k):
      return false
  result = true

var count = 0
var k = 1
while count < 5:
  if a(k):
    stdout.write k, ' '
    inc count
  inc k, 2
echo()
