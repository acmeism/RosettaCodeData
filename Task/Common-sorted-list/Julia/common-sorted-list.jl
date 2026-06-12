julia> sort(union([5,1,3,8,9,4,8,7], [3,5,9,8,4], [1,3,7,9]))
7-element Array{Int64,1}:
 1
 3
 4
 5
 7
 8
 9

julia> sort(union([2, 3, 4], split("3.14 is not an integer", r"\s+")), lt=(x, y) -> "$x" < "$y")
8-element Array{Any,1}:
 2
 3
  "3.14"
 4
  "an"
  "integer"
  "is"
  "not"

