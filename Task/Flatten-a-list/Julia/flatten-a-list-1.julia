using BenchmarkTools

flat(arr) = mapreduce(x -> x == [] || x[1] === x ? x : flat(x), vcat, arr, init=[])
