function isPrime(n)
    if n < 2 then
        return false
    end
    if n % 2 == 0 then
        return n == 2
    end
    if n % 3 == 0 then
        return n == 3
    end

    local p = 5
    while p * p <= n do
        if n % p == 0 then
            return false
        end
        p = p + 2
        if n % p == 0 then
            return false
        end
        p = p + 4
    end
    return true
end

function digitalRoot(n)
    if n == 0 then
        return 0
    else
        return 1 + (n - 1) % 9
    end
end

from = 500
to = 1000
count = 0
print("Nice primes between " .. from .. " and " .. to)
n = from
while n < to do
    if isPrime(digitalRoot(n)) and isPrime(n) then
        count = count + 1
        io.write(n)
        if count % 10 == 0 then
            print()
        else
            io.write(' ')
        end
    end
    n = n + 1
end
print(count .. " nice primes found.")
