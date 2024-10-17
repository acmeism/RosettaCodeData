julia> all(iseven, 1:5)              # not all integers between 1 and 5 are even.
false

julia> findfirst(iseven, 1:5)        # the first even integer is at index 2 in the range.
2

julia> count(iseven, 1:5)            # there are two even integers between 1 and 5.
2

julia> filter(iseven, 1:5)           # here are the even integers in the given range.
2-element Array{Int64,1}:
 2
 4

julia> map(iseven, 1:5)              # we apply our function to all integers in range.
5-element Array{Bool,1}:
 false
  true
 false
  true
 false
