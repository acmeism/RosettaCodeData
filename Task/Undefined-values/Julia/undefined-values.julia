julia> arr = [1, 2, nothing, 3]
4-element Array{Union{Nothing, Int64},1}:
 1
 2
  nothing
 3

julia> x = arr .+ 5
ERROR: MethodError: no method matching +(::Nothing, ::Int64)
Closest candidates are:
  +(::Any, ::Any, ::Any, ::Any...) at operators.jl:502
  +(::Complex{Bool}, ::Real) at complex.jl:292
  +(::Missing, ::Number) at missing.jl:93
  ...

julia> arr = [1, 2, missing, 3]
4-element Array{Union{Missing, Int64},1}:
 1
 2
  missing
 3

julia> x = arr .+ 5
4-element Array{Union{Missing, Int64},1}:
 6
 7
  missing
 8
