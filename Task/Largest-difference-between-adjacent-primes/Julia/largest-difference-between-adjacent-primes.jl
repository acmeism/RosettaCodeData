using Primes

function maxprimeinterval(nmax)
    pri = primes(nmax)
    diffs = [pri[i] - pri[i - 1] for i in 2:length(pri)]
    diff, idx = findmax(diffs)
    println("The maximum prime interval in primes up to $nmax is $diff: for example at [$(pri[idx]), $(pri[idx + 1])].")
end

foreach(n -> maxprimeinterval(10^n), 1:10)
