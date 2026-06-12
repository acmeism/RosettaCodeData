def divisor_sum(n)
    total = 1
    power = 2
    # Deal with powers of 2 first
    while (n & 1) == 0
        total = total + power

        power = power << 1
        n = n >> 1
    end
    # Odd prime factors up to the square root
    p = 3
    while p * p <= n
        sum = 1

        power = p
        while n % p == 0
            sum = sum + power

            power = power * p
            n = (n / p).floor
        end
        total = total * sum

        p = p + 2
    end
    # If n > 1 then it's prime
    if n > 1 then
        total = total * (n + 1)
    end
    return total
end

LIMIT = 100
print "Sum of divisors for the first ", LIMIT, " positive integers:\n"
for n in 1 .. LIMIT
    print "%4d" % [divisor_sum(n)]
    if n % 10 == 0 then
        print "\n"
    end
end
