using Test

isalnum(c::Char) = isletter(c) || isnumeric(c)

function appendchecksum(s::AbstractString)
    !all(isalnum, s) && throw(ArgumentError("invalid SEDOL number '$s'"))

	weights = [1, 3, 1, 7, 3, 9, 1]
    checksum = sum(weights[i] * parse(Int, s[i], base = 36) for i in eachindex(s))
    return s * string((10 - checksum % 10) % 10)
end

tests = ["710889", "B0YBKJ", "406566", "B0YBLH", "228276", "B0YBKL", "557910", "B0YBKR", "585284", "B0YBKT", "B00030"]
csums = ["7108899", "B0YBKJ7", "4065663", "B0YBLH2", "2282765", "B0YBKL9", "5579107", "B0YBKR5", "5852842", "B0YBKT7", "B000300"]

@testset "Checksums" begin
    for (t, c) in zip(tests, csums)
        @test appendchecksum(t) == c
    end
end
