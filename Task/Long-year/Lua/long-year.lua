function isLongYear (y)
    local function p (y)
        local f = math.floor
        return (y + f(y/4) - f(y/100) + f(y/400)) % 7
    end
    return p(y) == 4 or p(y - 1) == 3
end

print("Long years in the 21st century:")
for year = 2001, 2100 do
    if isLongYear(year) then io.write(year .. " ") end
end
