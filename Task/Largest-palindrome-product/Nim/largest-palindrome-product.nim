import strformat

proc reverse(n: int): int =
  result = n
  var r = 0
  while result > 0:
    r = result mod 10 + r * 10
    result = result div 10
  result = r

var pow = 10
for n in 2..7:
  var low = pow * 9
  pow *= 10
  var high = pow - 1
  stdout.write(&"Largest palindromic product of two {n}-digit integers: ")
  var nextN = false
  for i in countdown(high, low):
    var j = i.reverse()
    var p = i * pow + j
    # k can't be even nor end in 5 to produce a product ending in 9
    var k = high
    while k > low:
      if k mod 10 != 5:
        var l = p div k
        if l > high: break
        if p mod k == 0:
          stdout.write(&"{k} x {l} = {p}\n")
          nextN = true
          break
      k -= 2
    if nextN: break
