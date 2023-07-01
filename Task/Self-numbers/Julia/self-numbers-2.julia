const MAXCOUNT = 103 * 10000 * 10000 + 11 * 9 + 1

function dosieve!(sieve, digitsum9999)
    n = 1
    for a in 1:103, b in 1:10000
        s = digitsum9999[a] + digitsum9999[b] + n
        for c in 1:10000
            sieve[digitsum9999[c] + s] = true
            s += 1
        end
        n += 10000
    end
end

initdigitsum() = reverse!(vec([sum(k) for k in Iterators.product(9:-1:0, 9:-1:0, 9:-1:0, 9:-1:0)]))

function findselves()
    sieve = zeros(Bool, MAXCOUNT+1)
    println("Sieve time:")
    @time begin
        digitsum = initdigitsum()
        dosieve!(sieve, digitsum)
    end
    cnt = 1
    for i in 1:MAXCOUNT+1
        if !sieve[i]
            cnt > 50 && break
            print(i, " ")
            cnt += 1
        end
    end
    println()
    limit, cnt = 1, 0
    for i in 0:MAXCOUNT
        cnt += 1 - sieve[i + 1]
        if cnt == limit
            println(lpad(cnt, 10), lpad(i, 12))
            limit *= 10
        end
    end
end

@time findselves()
