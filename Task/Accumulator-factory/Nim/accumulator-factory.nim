proc accumulator(sum: float): auto =
  var sum = sum
  return proc (n: float): float =
    sum += n
    return sum

var x = accumulator(1)
echo x(5) # 6
echo x(2.3) # 8.3

var y = accumulator(1)
echo y(5) # 6
echo y(2.3) # 8.3

var z = accumulator(3)
echo z(5) # 8
echo z(2.3) # 10.3
echo x(0) # 8.3
echo z(0) # 10.3
