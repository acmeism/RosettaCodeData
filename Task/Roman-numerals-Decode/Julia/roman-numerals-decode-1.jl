function parseroman(rnum::AbstractString)
    romandigits = Dict('I' => 1, 'V' => 5, 'X' => 10, 'L' => 50,
                       'C' => 100, 'D' => 500, 'M' => 1000)
    mval = accm = 0
    for d in reverse(uppercase(rnum))
        val = try
            romandigits[d]
        catch
            throw(DomainError())
        end
        if val > mval maxval = val end
        if val < mval
            accm -= val
        else
            accm += val
        end
    end
    return accm
end
