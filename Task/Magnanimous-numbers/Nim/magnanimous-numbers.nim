func isPrime(n: Natural): bool =
  if n < 2: return
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  return true


func isMagnanimous(n: Natural): bool =
  var p = 10
  while true:
    let a = n div p
    let b = n mod p
    if a == 0: break
    if not isPrime(a + b): return false
    p *= 10
  return true


iterator magnanimous(): (int, int) =
  var n, count = 0
  while true:
    if n.isMagnanimous:
      inc count
      yield (count, n)
    inc n


for (i, n) in magnanimous():
  if i in 1..45:
    if i == 1: stdout.write "First 45 magnanimous numbers:\n  "
    stdout.write n, if i == 45: '\n' else: ' '

  elif i in 241..250:
    if i == 241: stdout.write "\n241st through 250th magnanimous numbers:\n  "
    stdout.write n, if i == 250: "\n" else: "  "

  elif i in 391..400:
    if i == 391: stdout.write "\n391st through 400th magnanimous numbers:\n  "
    stdout.write n, if i == 400: "\n" else: "  "

  elif i > 400:
    break
