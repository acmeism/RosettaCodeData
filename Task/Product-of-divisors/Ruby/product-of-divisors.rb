def divisor_count(n)
    total = 1
    # Deal with powers of 2 first
    while n % 2 == 0 do
        total = total + 1
        n = n >> 1
    end
    # Odd prime factors up to the square root
    p = 3
    while p * p <= n do
        count = 1
        while n % p == 0 do
            count = count + 1
            n = n / p
        end
        total = total * count
        p = p + 2
    end
    # If n > 1 then it's prime
    if n > 1 then
        total = total * 2
    end
    return total
end

def divisor_product(n)
    return (n ** (divisor_count(n) / 2.0)).floor
end

LIMIT = 50
print "Product of divisors for the first ", LIMIT, " positive integers:\n"
for n in 1 .. LIMIT
    print "%11d" % [divisor_product(n)]
    if n % 5 == 0 then
        print "\n"
    end
end
