using Formatting, Primes

const PMAX = 1_000_000_000
const pmb = primesmask(PMAX)
const primestoabillion = [i for i in 2:PMAX if pmb[i]]

tuplefitsat(k, tup, arr) = all(i -> arr[k + i] - arr[k] == tup[i], 1:length(tup))

function countprimetuples(tup, n)
    arr =  filter(i -> i <= n, primestoabillion)
    return count(k -> tuplefitsat(k, tup, arr), 1:length(arr) - length(tup))
end

println("Count of prime pairs from 1 to 1 billion: ",
    format(countprimetuples((2,), 1000000000), commas=true))
println("Count of a form of prime quads from 1 to 1 million: ",
    format(countprimetuples((2, 6, 8), 1000000), commas=true))
println("Count of a form of prime octets from 1 to 1 million: ",
    format(countprimetuples((2, 6, 12, 14, 20, 24, 26), 1000000), commas=true))
