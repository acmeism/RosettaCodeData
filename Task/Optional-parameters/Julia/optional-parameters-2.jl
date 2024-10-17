julia> data = {["a", "b", "c"], ["", "q", "z"], ["zap", "zip", "Zot"]}
3-element Array{Any,1}:
 ["a","b","c"]
 ["","q","z"]
 ["zap","zip","Zot"]

julia> sorttable(data, column=2, reverse=true) # named arguments
3-element Array{Any,1}:
 ["zap","zip","Zot"]
 ["","q","z"]
 ["a","b","c"]

julia> sorttable(data, >, 2) # the same thing, with positional arguments
3-element Array{Any,1}:
 ["zap","zip","Zot"]
 ["","q","z"]
 ["a","b","c"]
