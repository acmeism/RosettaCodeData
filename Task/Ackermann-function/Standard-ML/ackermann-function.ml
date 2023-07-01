fun a (0, n) = n+1
  | a (m, 0) = a (m-1, 1)
  | a (m, n) = a (m-1, a (m, n-1))
