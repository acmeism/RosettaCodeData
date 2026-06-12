def primeDigitsSum13(n)
    sum = 0
    while n > 0
        r = n % 10
        if r != 2 and r != 3 and r != 5 and r != 7 then
            return false
        end
        n = (n / 10).floor
        sum = sum + r
    end
    return sum == 13
end

c = 0
for i in 1 .. 1000000
    if primeDigitsSum13(i) then
        print "%6d " % [i]
        if c == 10 then
            c = 0
            print "\n"
        else
            c = c + 1
        end
    end
end
print "\n"
