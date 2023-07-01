-- initialize
local N = 2200
local ar = {}
for i=1,N do
    ar[i] = false
end

-- process
for a=1,N do
    for b=a,N do
        if (a % 2 ~= 1) or (b % 2 ~= 1) then
            local aabb = a * a + b * b
            for c=b,N do
                local aabbcc = aabb + c * c
                local d = math.floor(math.sqrt(aabbcc))
                if (aabbcc == d * d) and (d <= N) then
                    ar[d] = true
                end
            end
        end
    end
    -- print('done with a='..a)
end

-- print
for i=1,N do
    if not ar[i] then
        io.write(i.." ")
    end
end
print()
