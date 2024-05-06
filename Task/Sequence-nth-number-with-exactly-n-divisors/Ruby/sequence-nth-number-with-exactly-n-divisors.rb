def isPrime(n)
    return false if n < 2
    return n == 2 if n % 2 == 0
    return n == 3 if n % 3 == 0

    k = 5
    while k * k <= n
        return false if n % k == 0
        k = k + 2
    end

    return true
end

def getSmallPrimes(numPrimes)
    smallPrimes = [2]
    count = 0
    n = 3
    while count < numPrimes
        if isPrime(n) then
            smallPrimes << n
            count = count + 1
        end
        n = n + 2
    end
    return smallPrimes
end

def getDivisorCount(n)
    count = 1
    while n % 2 == 0
        n = (n / 2).floor
        count = count + 1
    end

    d = 3
    while d * d <= n
        q = (n / d).floor
        r = n % d
        dc = 0
        while r == 0
            dc = dc + count
            n = q
            q = (n / d).floor
            r = n % d
        end
        count = count + dc
        d = d + 2
    end
    if n != 1 then
        count = 2 * count
    end
    return count
end

MAX = 15
@smallPrimes = getSmallPrimes(MAX)

def OEISA073916(n)
    if isPrime(n) then
        return @smallPrimes[n - 1] ** (n - 1)
    end

    count = 0
    result = 0
    i = 1
    while count < n
        if n % 2 == 1 then
            # The solution for an odd (non-prime) term is always a square number
            root = Math.sqrt(i)
            if root * root != i then
                i = i + 1
                next
            end
        end
        if getDivisorCount(i) == n then
            count = count + 1
            result = i
        end
        i = i + 1
    end
    return result
end

n = 1
while n <= MAX
    print "A073916(", n, ") = ", OEISA073916(n), "\n"
    n = n + 1
end
