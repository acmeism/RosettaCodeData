using Primes, Formatting

function isErdős(p::Integer)
    isprime(p) || return false
    for i in 1:100
        kfac = factorial(i)
        kfac >= p && break
        isprime(p - kfac) && return false
    end
    return true
end

const Erdőslist = filter(isErdős, 1:1000000)
const E2500 = filter(x -> x < 2500, Erdőslist)

println(length(E2500), " Erdős primes < 2500: ", E2500)
println("The 7875th Erdős prime is ", format(Erdőslist[7875], commas=true))
