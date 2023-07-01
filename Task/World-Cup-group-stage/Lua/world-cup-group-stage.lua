function array1D(a, d)
    local m = {}
    for i=1,a do
        table.insert(m, d)
    end
    return m
end

function array2D(a, b, d)
    local m = {}
    for i=1,a do
        table.insert(m, array1D(b, d))
    end
    return m
end

function fromBase3(num)
    local out = 0
    for i=1,#num do
        local c = num:sub(i,i)
        local d = tonumber(c)
        out = 3 * out + d
    end
    return out
end

function toBase3(num)
    local ss = ""
    while num > 0 do
        local rem = num % 3
        num = math.floor(num / 3)
        ss = ss .. tostring(rem)
    end
    return string.reverse(ss)
end

games = { "12", "13", "14", "23", "24", "34" }

results = "000000"
function nextResult()
    if results == "222222" then
        return false
    end

    local res = fromBase3(results)
    results = string.format("%06s", toBase3(res + 1))

    return true
end

points = array2D(4, 10, 0)

repeat
    local records = array1D(4, 0)

    for i=1,#games do
        if results:sub(i,i) == '2' then
            local j = tonumber(games[i]:sub(1,1))
            records[j] = records[j] + 3
        elseif results:sub(i,i) == '1' then
            local j = tonumber(games[i]:sub(1,1))
            records[j] = records[j] + 1
            j = tonumber(games[i]:sub(2,2))
            records[j] = records[j] + 1
        elseif results:sub(i,i) == '0' then
            local j = tonumber(games[i]:sub(2,2))
            records[j] = records[j] + 3
        end
    end

    table.sort(records)
    for i=1,#records do
        points[i][records[i]+1] = points[i][records[i]+1] + 1
    end
until not nextResult()

print("POINTS       0    1    2    3    4    5    6    7    8    9")
print("-------------------------------------------------------------")
places = { "1st", "2nd", "3rd", "4th" }
for i=1,#places do
    io.write(places[i] .. " place")
    local row = points[i]
    for j=1,#row do
        io.write(string.format("%5d", points[5 - i][j]))
    end
    print()
end
