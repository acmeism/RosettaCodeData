julia> unit(v) = [v...]
unit (generic function with 1 method)

julia> import Base.bind

julia> bind(v, f) = f.(v)
bind (generic function with 5 methods)

julia> f1(x) = x + 1
f1 (generic function with 1 method)

julia> f2(x) = 2x
f2 (generic function with 1 method)

julia> bind(bind(unit([2, 3, 4]), f1), f2)
3-element Array{Int64,1}:
  6
  8
 10

julia> unit([2, 3, 4]) .|> f1 .|> f2
3-element Array{Int64,1}:
  6
  8
 10
