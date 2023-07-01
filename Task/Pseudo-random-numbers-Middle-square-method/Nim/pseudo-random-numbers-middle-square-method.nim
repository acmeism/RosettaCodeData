proc rand:int =
  var seed {.global.} = 675248
  seed = int(seed*seed) div 1000 mod 1000000
  return seed

for _ in 1..5: echo rand()
