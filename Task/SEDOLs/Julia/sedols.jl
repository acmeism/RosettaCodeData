using Base.Test

function appendchecksum(chars::AbstractString)
    if !all(isalnum, chars) throw(ArgumentError("invalid SEDOL number '$chars'")) end
    weights = [1, 3, 1, 7, 3, 9, 1]

    s = 0
    for (w, c) in zip(weights, chars)
        s += w * parse(Int, c, 36)
    end
    return string(chars, (10 - s % 10) % 10)
end

tests = ["710889", "B0YBKJ", "406566", "B0YBLH", "228276", "B0YBKL", "557910", "B0YBKR", "585284", "B0YBKT", "B00030"]
csums = ["7108899", "B0YBKJ7", "4065663", "B0YBLH2", "2282765", "B0YBKL9", "5579107", "B0YBKR5", "5852842", "B0YBKT7", "B000300"]

@testset "Checksums" begin
    for (t, c) in zip(tests, csums)
        @test appendchecksum(t) == c
    end
end
