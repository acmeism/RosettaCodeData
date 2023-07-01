using Primes

function nosuchsum(revsorted, num)
    if sum(revsorted) < num
        return true
    end
    for (i, n) in enumerate(revsorted)
        if n > num
            continue
        elseif n == num
            return false
        elseif !nosuchsum(revsorted[i+1:end], num - n)
            return false
        end
    end
    true
end

function isweird(n)
    if n < 70 || isodd(n)
        return false
    else
        f = [one(n)]
        for (p, x) in factor(n)
            f = reduce(vcat, [f*p^i for i in 1:x], init=f)
        end
        pop!(f)
        return sum(f) > n && nosuchsum(sort(f, rev=true), n)
    end
end

function testweird(N)
    println("The first $N weird numbers are: ")
    count, n = 0, 69
    while count < N
        if isweird(n)
            count += 1
            print("$n ")
        end
        n += 1
    end
end

testweird(25)
