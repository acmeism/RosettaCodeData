println([reduce(op, 1:5) for op in [+, -, *]])
println([foldl(op, 1:5) for op in [+, -, *]])
println([foldr(op, 1:5) for op in [+, -, *]])
