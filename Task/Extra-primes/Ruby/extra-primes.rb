def nextPrimeDigitNumber(n)
    if n == 0 then
        return 2
    end
    if n % 10 == 2 then
        return n + 1
    end
    if n % 10 == 3 or n % 10 == 5 then
        return n + 2
    end
    return 2 + nextPrimeDigitNumber((n / 10).floor) * 10
end

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
    if n % 5 == 0 then
        return n == 5
    end

    wheel = [4, 2, 4, 2, 4, 6, 2, 6]
    p = 7
    loop do
        for w in wheel
            if p * p > n then
                return true
            end
            if n % p == 0 then
                return false
            end
            p = p + w
        end
    end
end

def digitSum(n)
    sum = 0
    while n > 0
        sum = sum + n % 10
        n = (n / 10).floor
    end
    return sum
end

LIMIT = 10000
p = 0
n = 0

print "Extra primes under %d:\n" % [LIMIT]
while p < LIMIT
    p = nextPrimeDigitNumber(p)
    if isPrime(p) and isPrime(digitSum(p)) then
        n = n + 1
        print "%2d: %d\n" % [n, p]
    end
end
print "\n"
