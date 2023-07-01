function buildArray(size, value)
    local tbl = {}
    for i=1, size do
        table.insert(tbl, value)
    end
    return tbl
end

MU_MAX = 1000000
sqroot = math.sqrt(MU_MAX)
mu = buildArray(MU_MAX, 1)

for i=2, sqroot do
    if mu[i] == 1 then
        -- for each factor found, swap + and -
        for j=i, MU_MAX, i do
            mu[j] = mu[j] * -i
        end
        -- square factor = 0
        for j=i*i, MU_MAX, i*i do
            mu[j] = 0
        end
    end
end

for i=2, MU_MAX do
    if mu[i] == i then
        mu[i] = 1
    elseif mu[i] == -i then
        mu[i] = -1
    elseif mu[i] < 0 then
        mu[i] = 1
    elseif mu[i] > 0 then
        mu[i] = -1
    end
end

print("First 199 terms of the mobius function are as follows:")
io.write("    ")
for i=1, 199 do
    io.write(string.format("%2d  ", mu[i]))
    if (i + 1) % 20 == 0 then
        print()
    end
end
