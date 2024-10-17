#!/usr/bin/julia

function compose(f::Function, g::Function)
  return x -> f(g(x))
end

value = 0.5
for pair in [(sin, asin), (cos, acos), (x -> x^3, x -> x^(1/3))]
  func, inverse = pair
  println(compose(func, inverse)(value))
end
