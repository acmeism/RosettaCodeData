-- for Lua 5.1/5.2 use math.floor(n/2) instead of n>>1, and n%2 instead of n&1

function dec2bin(n)
    return n>1 and dec2bin(n>>1)..(n&1) or n
end

print(dec2bin(5))
print(dec2bin(50))
print(dec2bin(9000))
