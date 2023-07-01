using Primes, Formatting

function doublemyindex(n=42)
    shown = 0
    i = BigInt(n)
    while shown < n
        if isprime(i + 1)
            shown += 1
            println("The index is ", format(shown, commas=true), " and ",
                                     format(i + 1, commas=true), " is prime.")
            i += i
        end
        i += 1
    end
end

doublemyindex()
