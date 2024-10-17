using Primes

function primordials(N)
    print("The first $N primorial indices sequentially producing primorial primes are: 1 ")
    primorial = 1
    count = 1
    p = 3
    prod = BigInt(2)
    while true
        if isprime(p)
            prod *= p
            primorial += 1
            if isprime(prod + 1) || isprime(prod - 1)
                print("$primorial ")
                count += 1
                if count == N
                    break
                end
            end
        end
        p += 2
    end
end

primordials(20)
