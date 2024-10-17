# create an array with one object in it
a = ["foo"]

# Empty array literals always need a type specification:
[] of Int32 # => Array(Int32).new

# The array's generic type argument T is inferred from the types of the elements inside the literal. When all elements of the array have the same type, T equals to that. Otherwise it will be a union of all element types.
[1, 2, 3]         # => Array(Int32)
[1, "hello", 'x'] # => Array(Int32 | String | Char)

# An explicit type can be specified by immediately following the closing bracket with of and a type, each separated by whitespace. This overwrites the inferred type and can be used for example to create an array that holds only some types initially but can accept other types later.
array_of_numbers = [1, 2, 3] of Float64 | Int32 # => Array(Float64 | Int32)
array_of_numbers << 0.5                         # => [1, 2, 3, 0.5]

array_of_int_or_string = [1, 2, 3] of Int32 | String # => Array(Int32 | String)
array_of_int_or_string << "foo"                      # => [1, 2, 3, "foo"]

# percent array literals
%w(one two three) # => ["one", "two", "three"]
%i(one two three) # => [:one, :two, :three]
