let rec a = function
  | 0, n -> (n+1)
  | m, 0 -> a(m-1, 1)
  | m, n -> a(m-1, a(m, n-1))
