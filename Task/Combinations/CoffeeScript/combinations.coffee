combinations = (n, p) ->
  return [ [] ] if p == 0
  i = 0
  combos = []
  combo = []
  while combo.length < p
    if i < n
      combo.push i
      i += 1
    else
      break if combo.length == 0
      i = combo.pop() + 1

    if combo.length == p
      combos.push clone combo
      i = combo.pop() + 1
  combos

clone = (arr) -> (n for n in arr)

N = 5
for i in [0..N]
  console.log "------ #{N} #{i}"
  for combo in combinations N, i
    console.log combo
