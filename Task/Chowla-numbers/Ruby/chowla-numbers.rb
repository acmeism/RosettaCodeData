def chowla(n)
    sum = 0
    i = 2
    while i * i <= n do
        if n % i == 0 then
            sum = sum + i
            j = n / i
            if i != j then
                sum = sum + j
            end
        end
        i = i + 1
    end
    return sum
end

def main
    for n in 1 .. 37 do
        puts "chowla(%d) = %d" % [n, chowla(n)]
    end

    count = 0
    power = 100
    for n in 2 .. 10000000 do
        if chowla(n) == 0 then
            count = count + 1
        end
        if n % power == 0 then
            puts "There are %d primes < %d" % [count, power]
            power = power * 10
        end
    end

    count = 0
    limit = 350000000
    k = 2
    kk = 3
    loop do
        p = k * kk
        if p > limit then
            break
        end
        if chowla(p) == p - 1 then
            puts "%d is a perfect number" % [p]
            count = count + 1
        end
        k = kk + 1
        kk = kk + k
    end
    puts "There are %d perfect numbers < %d" % [count, limit]
end

main()
