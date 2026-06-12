proc drawMosaicMatrix(side: Positive) =
  var start = 1
  for i in 0..<side:
    var c = start
    for j in 0..<side:
      stdout.write c
      c = 1 - c
    echo()
    start = 1 - start

echo "6x6 matrix:\n"
drawMosaicMatrix(6)

echo "\n7x7 matrix:\n"
drawMosaicMatrix(7)
