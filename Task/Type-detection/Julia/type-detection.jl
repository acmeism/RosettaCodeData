julia> a = 1
1

julia> typeof(a)
Int32

julia> b = 1.0
1.0

julia> typeof(b)
Float64

julia> 1.0 isa Number
true

julia> 1.0 isa Int
false

julia> 1 isa Int
true

julia> typeof("hello")
String

julia> typeof(typeof("hello"))
DataType

julia> typeof(Set([1,3,4]))
Set{Int64}

julia> 1 isa String
false

julia> "1" isa Number
false

julia> "1" isa String
true

julia> isa(1.0,Float32)
false

julia> isa(1.0,Float64)
true

