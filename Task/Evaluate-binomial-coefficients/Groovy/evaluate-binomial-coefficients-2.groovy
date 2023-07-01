assert combinations(20, 0) == combinations(20, 20)
assert combinations(20, 10) == (combinations(19, 9) + combinations(19, 10))
assert combinations(5, 3) == 10
println combinations(5, 3)
