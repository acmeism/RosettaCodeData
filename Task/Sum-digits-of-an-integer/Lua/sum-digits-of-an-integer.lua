function sum_digits(n, base)
    sum = 0
    while n > 0.5 do
        m = math.floor(n / base)
        digit = n - m * base
        sum = sum + digit
        n = m
    end
    return sum
end

print(sum_digits(1, 10))
print(sum_digits(1234, 10))
print(sum_digits(0xfe, 16))
print(sum_digits(0xf0e, 16))
