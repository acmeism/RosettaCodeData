gcd = (x, y) ->
  [1..(Math.min x, y)].reduce (acc, v) ->
    if x % v == 0 and y % v == 0 then v else acc
