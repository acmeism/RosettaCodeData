from algorithm import sorted

func search(): int =
  var start = 100
  while true:
    for i in countup(start + 2, 10 * start div 6, 3):
      let digits = sorted($i)
      block check:
        for j in 2..6:
          if sorted($(i * j)) != digits:
            break check
        # Found.
        return i
    start *= 10

let n = search()
echo " n = ", n
for k in 2..6:
  echo k, "n = ", k * n
