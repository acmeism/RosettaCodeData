let rec sudan = function
  | 0, x, y -> x + y
  | _, x, 0 -> x
  | n, x, y -> let x' = sudan (n, x, pred y) in sudan (pred n, x', x' + y)
