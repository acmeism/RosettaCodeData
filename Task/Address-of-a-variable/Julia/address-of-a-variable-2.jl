julia> A = [1, 2.3, 4]
3-element Array{Float64,1}:
 1.0
 2.3
 4.0

julia> p = pointer(A)
Ptr{Float64} @0x0000000113f70d60

julia> unsafe_load(p, 3)
4.0

julia> unsafe_store!(p, 3.14159, 3)
julia> A
3-element Array{Float64,1}:
 1.0
 2.3
 3.14149

julia> pointer_to_array(p, (3,))
3-element Array{Float64,1}:
 1.0
 2.3
 3.14149
