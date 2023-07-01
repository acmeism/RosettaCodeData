using Printf

isnumber(s::AbstractString) = tryparse(Float64, s) isa Number

tests = ["1", "-121", "one", "pi", "1 + 1", "NaN", "1234567890123456789", "1234567890123456789123456789",
        "1234567890123456789123456789.0", "1.3", "1.4e10", "Inf", "1//2", "1.0 + 1.0im"]

for t in tests
    fl = isnumber(t) ? "is" : "is not"
    @printf("%35s %s a direct numeric literal.\n", t, fl)
end
