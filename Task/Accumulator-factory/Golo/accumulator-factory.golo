module accumulatorfactory

function accumulator = |n| {
  let number = DynamicVariable(n)
  return |i| {
    number: value(number: value() + i)
    return number: value()
  }
}

function main = |args| {
  let x = accumulator(1)
  x(5)
  accumulator(3)
  println(x(2.3))
}
