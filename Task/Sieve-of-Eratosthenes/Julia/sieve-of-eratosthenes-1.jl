# Returns an array of positive prime numbers less than or equal to lim
function sieve(lim :: Int)
    if lim < 2 return [] end
    limi :: Int = (lim - 1) ÷ 2 # calculate the required array size
    isprime :: Array{Bool} = trues(limi)
    llimi :: Int = (isqrt(lim) - 1) ÷ 2 # and calculate maximum root prime index
    result :: Array{Int} = [2]  #Initial array
    for i in 1:limi
        if isprime[i]
            p = i + i + 1 # 2i + 1
            if i <= llimi
                for j = (p*p-1)>>>1:p:limi # quick shift/divide in case LLVM doesn't optimize divide by 2 away
                    isprime[j] = false
                end
            end
            push!(result, p)
        end
    end
    return result
end
