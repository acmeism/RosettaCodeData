// "a" and "b" in sorting arrays, used to provide custom sorting conditions
mut numbers := [1, 3, 2]
numbers.sort()
println(numbers)
numbers.sort(a > b) // reverse sort
println(numbers)
