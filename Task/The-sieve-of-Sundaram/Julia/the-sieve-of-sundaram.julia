"""
The sieve of Sundaram is a simple deterministic algorithm for finding all the
prime numbers up to a specified integer. This function is modified from the
Python example Wikipedia entry wiki/Sieve_of_Sundaram, to give primes to the
nth prime rather than the Wikipedia function that gives primes less than n.
"""
function sieve_of_Sundaram(nth, print_all=true)
    @assert nth > 0
    k = Int(round(1.2 * nth * log(nth)))  # nth prime is at about n * log(n)
    integers_list = trues(k)
    for i in 1:k
        j = i
        while i + j + 2 * i * j < k
            integers_list[i + j + 2 * i * j + 1] = false
            j += 1
        end
    end
    pcount = 0
    for i in 1:k + 1
        if integers_list[i + 1]
            pcount += 1
            if print_all
                print(lpad(2 * i + 1, 4), pcount % 10 == 0 ? "\n" : "")
            end
            if pcount == nth
                println("\nSundaram primes start with 3. The $(nth)th Sundaram prime is $(2 * i + 1).")
                break
            end
        end
    end
end

sieve_of_Sundaram(100)
@time sieve_of_Sundaram(1000000, false)

println("\nChecking:")
using Primes; @show count(primesmask(15485867))
@time count(primesmask(15485867))
