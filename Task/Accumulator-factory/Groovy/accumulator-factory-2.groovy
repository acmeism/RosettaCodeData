def x = accumulator(1)

println x()
assert x() instanceof Integer

println x(5)
assert x() instanceof Integer

def y = accumulator(3)
println y()
assert y() instanceof Integer

println x(2.3)
assert x() instanceof BigDecimal

println y(10)
assert y() instanceof Integer

println y(200L)
assert y() instanceof Long

println y(2.25D)
assert y() instanceof Double
