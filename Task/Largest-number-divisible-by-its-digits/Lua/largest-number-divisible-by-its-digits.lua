function isDivisible(n)
    local t = n
    local a = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

    while t ~= 0 do
        local r = t % 10
        if r == 0 then
            return false
        end
        if n % r ~= 0 then
            return false
        end
        if a[r + 1] > 0 then
            return false
        end
        a[r + 1] = 1
        t = math.floor(t / 10)
    end

    return true
end

for i=9999999999,0,-1 do
    if isDivisible(i) then
        print(i)
        break
    end
end
