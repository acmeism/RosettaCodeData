proc accumulator[T: SomeNumber](x: T): auto =
  var sum = x
  result = proc (n: T): T =
             sum += n
             result = sum

let x = accumulator(1)
echo x(5)   # 6
echo x(2)   # 8
let y = accumulator(3.5)
echo y(2)   # 5.5
echo y(3)   # 8.5
