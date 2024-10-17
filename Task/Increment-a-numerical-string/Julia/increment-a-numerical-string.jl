import Base.+
Base.:+(s::AbstractString, n::Real) = string((x = tryparse(Int, s)) isa Int ? x + 1 : parse(Float64, s) + 1)
@show "125" + 1
@show "125.15" + 1
@show "1234567890987654321" + 1
