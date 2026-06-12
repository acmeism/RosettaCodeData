using Formatting
import Base.show

Base.show(io::IO, x::Float64) = print(io, format(x, commas=true))
Base.show(io::IO, x::Int) = print(io, format(x, commas=true, parens=true))

println("15.1 + 31415926.5 = $(15.1 + 31415926.5)")
println("10000000000 / -3 = $(10000000000 / -3)")
println("2345 * 76 = $(2345 * 76), 2345 * -9876 = $(2345 * -9876)")
