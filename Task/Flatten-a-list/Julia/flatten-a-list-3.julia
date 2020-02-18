flat2(arr) = (while any(a -> a isa Vector, arr) arr = collect(Iterators.flatten(arr)) end; arr)

arr = [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]

@show flat(arr)
@show flat1(arr)
@show flat2(arr)

@btime flat(arr)
@btime flat1(arr)
@btime flat2(arr)
