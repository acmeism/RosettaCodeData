block outer:
  for i in 0..1000:
    for j in 0..1000:
      if i + j == 3:
        break outer
