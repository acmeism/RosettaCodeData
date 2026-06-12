function prime_digits_sum_13(n)
    local sum = 0
    while n > 0 do
        local r = n % 10
        if r ~= 2 and r ~= 3 and r ~= 5 and r ~= 7 then
            return false
        end
        n = math.floor(n / 10)
        sum = sum + r
    end
    return sum == 13
end

local c = 0
for i=1,999999 do
    if prime_digits_sum_13(i) then
        io.write(string.format("%6d ", i))
        if c == 10 then
            c = 0
            print()
        else
            c = c + 1
        end
    end
end
print()
