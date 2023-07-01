function digital_root(n, base)
    p = 0
    while n > 9.5 do
        n = sum_digits(n, base)
        p = p + 1
    end
    return n, p
end

print(digital_root(627615, 10))
print(digital_root(39390, 10))
print(digital_root(588225, 10))
print(digital_root(393900588225, 10))
