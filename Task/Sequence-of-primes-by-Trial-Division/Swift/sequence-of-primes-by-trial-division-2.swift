var primes = [2]

func trialPrimes(_ max:Int){
// fill array 'primes' with primes <= max, 1s for small values like 400_000
    var cand = 3
    while cand <= max {
        for p in primes {
            if cand % p == 0 {
                break
            }
            if p*p > cand {
                primes.append(cand)
                break
            }
        }
        cand += 2
    }
}

trialPrimes(100)
print(primes)
