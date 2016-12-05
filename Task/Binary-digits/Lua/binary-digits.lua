function dec2bin (n)
    local bin = ""
    while n > 0 do
        bin = n % 2 .. bin
        n = math.floor(n / 2)
    end
    return bin
end

print(dec2bin(5))
print(dec2bin(50))
print(dec2bin(9000))
