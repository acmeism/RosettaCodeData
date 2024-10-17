using Primes, Formatting

function chowla(n)
    if n < 1
        throw("Chowla function argument must be positive")
    elseif n < 4
        return zero(n)
    else
        f = [one(n)]
        for (p,e) in factor(n)
            f = reduce(vcat, [f*p^j for j in 1:e], init=f)
        end
        return sum(f) - one(n) - n
    end
end

function countchowlas(n, asperfect=false, verbose=false)
    count = 0
    for i in 2:n  # 1 is not prime or perfect so skip
        chow = chowla(i)
        if (asperfect && chow == i - 1) || (!asperfect && chow == 0)
            count += 1
            verbose && println("The number $(format(i, commas=true)) is ", asperfect ? "perfect." : "prime.")
        end
    end
    count
end

function testchowla()
    println("The first 37 chowla numbers are:")
    for i in 1:37
        println("Chowla($i) is ", chowla(i))
    end
    for i in [100, 1000, 10000, 100000, 1000000, 10000000]
        println("The count of the primes up to $(format(i, commas=true)) is $(format(countchowlas(i), commas=true))")
    end
    println("The count of perfect numbers up to 35,000,000 is $(countchowlas(35000000, true, true)).")
end

testchowla()
