entropy(s) = -sum(x -> x * log(2, x), count(x -> x == c, s) / length(s) for c in unique(s))
@show entropy("1223334444")
@show entropy([1, 2, 3, 1, 2, 1, 2, 3, 1, 2, 3, 4, 5])
