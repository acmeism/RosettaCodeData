for a in [@[1, 2, 0], @[3, 4, -1, 1], @[7, 8, 9, 11, 12], @[-5, -2, -6, -1]]:
  for n in 1..int.high:
    if n notin a:
      echo a, " → ", n
      break
