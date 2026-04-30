local function isPerfect(x)
    local sum = 0
    for i = 1, x-1 do
        if x % i == 0 then sum = sum + i end
    end
    return sum == x
end
for i = 1, 10000 do
    if isPerfect( i ) then io.write( " "..i ) end
end
