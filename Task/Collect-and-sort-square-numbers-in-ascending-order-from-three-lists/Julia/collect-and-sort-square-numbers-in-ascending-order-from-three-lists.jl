lists = [
    [3,4,34,25,9,12,36,56,36],
    [2,8,81,169,34,55,76,49,7],
    [75,121,75,144,35,16,46,35]
]

squares = reduce(vcat, [[s for s in list if isqrt(s)^2 == s] for list in lists])
sort!(squares)
println(squares)
