def sudan(n, x, y)
  return x + y if n == 0
  return x if y == 0

  sudan(n - 1, sudan(n, x, y - 1), sudan(n, x, y - 1) + y)
end
