for j in loop((-three, 3^3, three),
              (-seven, seven, x),
              (555, 550 - y),
              (22, -28, three),
              (1927, 1939, 1),
              (x, y, -z),
              (11^x, 11^x + one)):
  sum += abs(j)
  if abs(prod) < 2^27 and j != 0: prod *= j
