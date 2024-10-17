using Distributed
@everywhere include_string(Main, $(read("count_heads.jl", String)), "count_heads.jl")

a = @spawn count_heads(100000000) # runs on an available processor
b = @spawn count_heads(100000000) # runs on another available processor

println(fetch(a)+fetch(b)) # total heads of 200 million coin flips, half on each CPU
