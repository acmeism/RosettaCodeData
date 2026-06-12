primeNumbers    = sum(perms(1:7).*repmat((10*ones(1,7)).^(7-1:-1:0), [factorial(7),1]),'c')
mprintf('The largest pandigital prime is %u', max(primeNumbers(find(members(primeNumbers, primes(7.7e6))==1))))
