function valid(n,nuts)
    local k = n
    local i = 0
    while k ~= 0 do
        if (nuts % n) ~= 1 then
            return false
        end
        k = k - 1
        nuts = nuts - 1 - math.floor(nuts / n)
    end
    return nuts ~= 0 and (nuts % n == 0)
end

for n=2, 9 do
    local x = 0
    while not valid(n, x) do
        x = x + 1
    end
    print(n..": "..x)
end
