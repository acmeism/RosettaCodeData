function sieve(n :: Int)
    isprime = trues(n)
    isprime[1] = false
    for p in 2:n
        if isprime[p]
            j = p * p
            if j > n
                return findall(isprime)
            else
                for k in j:p:n
                  isprime[k] = false
                end
            end
        end
    end
end
