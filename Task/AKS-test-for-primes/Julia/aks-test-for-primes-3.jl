function isaksprime(n::Int64)
    if n < 2
        return false
    end
    for c in polycoefs(n)[2:(end-1)]
        if c%n != 0
            return false
        end
    end
    return true
end
