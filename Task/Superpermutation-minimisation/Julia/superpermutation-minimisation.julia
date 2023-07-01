const nmax = 12

function r!(n, s, pos, count)
    if n == 0
        return false
    end
    c = s[pos + 1 - n]
    count[n + 1] -= 1
    if count[n + 1] == 0
        count[n + 1] = n
        if r!(n - 1, s, pos, count) == 0
            return false
        end
    end
    s[pos + 1] = c
    pos += 1
    true
end

function superpermutation(n)
    count = zeros(nmax)
    pos = n
    superperm = zeros(UInt8, n < 2 ? n : mapreduce(factorial, +, 1:n))
    for i in 0:n-1
        count[i + 1] = i
        superperm[i + 1] = Char(i + '0')
    end
    count[n + 1] = n
    while r!(n, superperm, pos, count) ; end
    superperm
end

function testsuper(N, verbose=false)
    for i in 0:N-1
        s = superpermutation(i)
        println("Superperm($i) has length $(length(s)) ", (verbose ? String(s) : ""))
    end
end

testsuper(nmax)
