using BenchmarkTools

arr = [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]

@show flat_mapreduce(arr)
@show flat_recursion(arr)
@show flat_iterators(arr)

@btime flat_mapreduce($arr)
@btime flat_recursion($arr)
@btime flat_iterators($arr)
