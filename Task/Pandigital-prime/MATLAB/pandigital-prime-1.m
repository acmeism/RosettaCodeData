primeNumbers    = sum(perms(0:7).*repmat((10*ones(1,8)).^(8-1:-1:0), [factorial(8),1]),'c')
mprintf('The largest pandigital prime is %u.', max(primeNumbers(find(members(primeNumbers, primes(7.7e7))==1))))
