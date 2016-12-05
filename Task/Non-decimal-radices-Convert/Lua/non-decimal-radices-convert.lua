function dec2base (base, n)
    local result, digit = ""
    while n > 0 do
        digit = n % base
        if digit > 9 then digit = string.char(digit + 87) end
        n = math.floor(n / base)
        result = digit .. result
    end
    return result
end

local x = dec2base(16, 26)
print(x)                    --> 1a
print(tonumber(x, 16))      --> 26
