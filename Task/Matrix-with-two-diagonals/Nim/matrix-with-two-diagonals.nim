proc drawMatrix(side: Positive) =
  let last = side - 1
  for i in 0..<side:
    for j in 0..<side:
      stdout.write if i == j or i == last - j: "1 " else: "0 "
    echo()

drawMatrix(6)
