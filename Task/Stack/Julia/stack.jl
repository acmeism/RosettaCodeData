stack = Int[]           # []
@show push!(stack, 1)   # [1]
@show push!(stack, 2)   # [1, 2]
@show push!(stack, 3)   # [1, 2, 3]
@show pop!(stack)       # 3
@show length(stack)     # 2
@show empty!(stack)     # []
@show isempty(stack)    # true
