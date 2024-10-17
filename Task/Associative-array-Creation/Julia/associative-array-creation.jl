dict = Dict('a' => 97, 'b' => 98) # list keys/values
# Dict{Char,Int64} with 2 entries:
#   'b' => 98
#   'a' => 97

dict = Dict(c => Int(c) for c = 'a':'d') # dict comprehension
# Dict{Char,Int64} with 4 entries:
#   'b' => 98
#   'a' => 97
#   'd' => 100
#   'c' => 99

dict['é'] = 233; dict # add an element
# Dict{Char,Int64} with 3 entries:
#   'b' => 98
#   'a' => 97
#   'é' => 233

emptydict = Dict() # create an empty dict
# Dict{Any,Any} with 0 entries

dict["a"] = 1 # type mismatch
# ERROR: MethodError: Cannot `convert` an object of type String to an object of type Char

typeof(dict) # type is infered correctly
# Dict{Char,Int64}
