const x = 5

# @assert macro checks the supplied conditional expression, with the expression
# returned in the failed-assertion message
@assert x == 42
# ERROR: LoadError: AssertionError: x == 42

# Julia also has type assertions of the form, x::Type which can be appended to
# variable for type-checking at any point
x::String
# ERROR: LoadError: TypeError: in typeassert, expected String, got Int64
