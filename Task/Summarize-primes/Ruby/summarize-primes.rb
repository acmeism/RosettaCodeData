def isPrime(n)
    if n < 2 then
        return false
    end

    if n % 2 == 0 then
        return n == 2
    end
    if n % 3 == 0 then
        return n == 3
    end

    i = 5
    while i * i <= n
        if n % i == 0 then
            return false
        end
        i += 2

        if n % i == 0 then
            return false
        end
        i += 4
    end
    return true
end

START = 1
STOP = 1000

sum = 0
count = 0
sc = 0

for p in START .. STOP
    if isPrime(p) then
        count += 1
        sum += p
        if isPrime(sum) then
            print "The sum of %3d primes in [2, %3d] is %5d which is also prime\n" % [count, p, sum]
            sc += 1
        end
    end
end
print "There are %d summerized primes in [%d, %d]\n" % [sc, START, STOP]
