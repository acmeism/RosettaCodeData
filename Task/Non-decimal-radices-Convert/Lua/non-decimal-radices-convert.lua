function dec2base (base, n)
    local result = ""
    repeat
        local digit = n % base
        if digit > 9 then
            digit = string.char(digit + 87)
        end
        result = digit .. result
        n = n // base
    until n == 0
    return result
end

local x = dec2base(16, 26)
print(x)                    --> 1a
print(tonumber(x, 16))      --> 26
