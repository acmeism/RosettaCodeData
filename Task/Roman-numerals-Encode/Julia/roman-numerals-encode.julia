using Printf

function romanencode(n::Integer)
    if n < 1 || n > 4999 throw(DomainError()) end

    DR = [["I", "X", "C", "M"] ["V", "L", "D", "MMM"]]
    rnum = ""
    for (omag, d) in enumerate(digits(n))
        if d == 0
            omr = ""
        elseif d <  4
            omr = DR[omag, 1] ^ d
        elseif d == 4
            omr = DR[omag, 1] * DR[omag, 2]
        elseif d == 5
            omr = DR[omag, 2]
        elseif d <  9
            omr = DR[omag, 2] * DR[omag, 1] ^ (d - 5)
        else
            omr = DR[omag, 1] * DR[omag + 1, 1]
        end
        rnum = omr * rnum
    end
    return rnum
end

testcases = [1990, 2008, 1668]
append!(testcases, rand(1:4999, 12))
testcases = unique(testcases)

println("Test romanencode, arabic => roman:")
for n in testcases
    @printf("%-4i => %s\n", n, romanencode(n))
end
