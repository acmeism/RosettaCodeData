def sequence = hailstone(27)
assert sequence.size() == 112
assert sequence[0..3] == [27, 82, 41, 124]
assert sequence[-4..-1] == [8, 4, 2, 1]

def results = (1..100000).collect { [n:it, size:hailstone(it).size()] }.max { it.size }
println results
