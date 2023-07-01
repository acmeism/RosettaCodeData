function isqrt(x)
    local q = 1
    local r = 0
    while q <= x do
        q = q << 2
    end
    while q > 1 do
        q = q >> 2
        local t = x - r - q
        r = r >> 1
        if t >= 0 then
            x = t
            r = r + q
        end
    end
    return r
end

print("Integer square root for numbers 0 to 65:")
for n=0,65 do
    io.write(isqrt(n) .. ' ')
end
print()
print()

print("Integer square roots of oddd powers of 7 from 1 to 21:")
print(" n |              7 ^ n | isqrt(7 ^ n)")
local p = 7
local n = 1
while n <= 21 do
    print(string.format("%2d | %18d | %12d", n, p, isqrt(p)))
    ----------------------
    n = n + 2
    p = p * 49
end
