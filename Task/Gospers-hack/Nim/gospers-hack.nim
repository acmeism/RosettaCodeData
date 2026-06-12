proc gospersHack(n: int): int =
  let c = n and - n
  let r = n + c
  (((r xor n) shr 2) div c) or r

for number in [1,3,7,15]:
  var number = number
  stdout.write number, ": "
  for i in 1..10:
    number = gospersHack(number)
    stdout.write number, " "
  stdout.write '\n'
