ggt = (x,y) ->
  max_teiler = Math.min(x,y)
  ggt = 0
  for teiler in [1..max_teiler]
    if x % teiler == 0 and y % teiler == 0
      ggt = teiler
  return ggt

alert ggt(40902,24140)
