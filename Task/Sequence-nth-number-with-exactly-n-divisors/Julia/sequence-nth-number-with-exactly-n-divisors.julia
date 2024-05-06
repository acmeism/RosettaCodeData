using Primes

function countdivisors(n)
    f = [one(n)]
    for (p, e) in factor(n)
        f = reduce(vcat, [f * p ^ j for j in 1:e], init = f)
    end
    length(f)
end

function nthwithndivisors(N)
    parray = findall(primesmask(100 * N))
    for i = 1:N
        if isprime(i)
            println("$i : ", BigInt(parray[i])^(i-1))
        else
            k = 0
            for j in 1:100000000000
                if (iseven(i) || Int(floor(sqrt(j)))^2 == j) &&
                    i == countdivisors(j) && (k += 1) == i
                    println("$i : $j")
                    break
                end
            end
        end
    end
end

nthwithndivisors(35)
