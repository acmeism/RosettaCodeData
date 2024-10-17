const functions = Dict{String,Function}(
    "foo" => x -> 42 + x,
    "bar" => x -> 42 * x)

@show functions["foo"](3)
@show functions["bar"](3)
