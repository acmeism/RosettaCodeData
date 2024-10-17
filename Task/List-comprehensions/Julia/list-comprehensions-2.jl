julia> ((x, y, z) for x = 1:n for y = x:n for z = y:n if x^2 + y^2 == z^2)
Base.Flatten{Base.Generator{UnitRange{Int64},##33#37}}(Base.Generator{UnitRange{Int64},##33#37}(#33,1:20))

julia> collect(ans)
6-element Array{Tuple{Int64,Int64,Int64},1}:
 (3,4,5)
 (5,12,13)
 (6,8,10)
 (8,15,17)
 (9,12,15)
 (12,16,20)
