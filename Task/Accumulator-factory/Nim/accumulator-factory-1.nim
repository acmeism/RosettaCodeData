proc accumulator[T: SomeNumber](x: T): auto =
  var sum = float(x)
  result = proc (n: float): float =
             sum += n
             result = sum

let acc = accumulator(1)
echo acc(5)             # 6
discard accumulator(3)  # Create another accumulator.
echo acc(2.3)           # 8.3
