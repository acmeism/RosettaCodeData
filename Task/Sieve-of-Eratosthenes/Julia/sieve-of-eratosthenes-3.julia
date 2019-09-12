function sieve2(n :: Int)
    ni = (n - 1) ÷ 2
    isprime = trues(ni)
    for i in 1:ni
        if isprime[i]
            j = 2i * (i + 1)
            if j > ni
                m = findall(isprime)
                map!((i::Int) -> 2i + 1, m, m)
                return pushfirst!(m, 2)
            else
                p = 2i + 1
                while j <= ni
                  isprime[j] = false
                  j += p
                end
            end
        end
    end
end
