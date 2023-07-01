iterator lookAndSay(n: int): string =
  var current = "1"
  yield current
  for round in 2..n:
    var ch = current[0]
    var count = 1
    var next = ""
    for i in 1..current.high:
      if current[i] == ch:
        inc count
      else:
        next.add $count & ch
        ch = current[i]
        count = 1
    current = next & $count & ch
    yield current

for s in lookAndSay(12):
  echo s
