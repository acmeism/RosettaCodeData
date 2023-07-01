function array1D(n, v)
    local tbl = {}
    for i=1,n do
        table.insert(tbl, v)
    end
    return tbl
end

function array2D(h, w, v)
    local tbl = {}
    for i=1,h do
        table.insert(tbl, array1D(w, v))
    end
    return tbl
end

function mod(m, n)
    m = math.floor(m)
    local result = m % n
    if result < 0 then
        result = result + n
    end
    return result
end

function getA004290(n)
    if n == 1 then
        return 1
    end
    local arr = array2D(n, n, 0)
    arr[1][1] = 1
    arr[1][2] = 1
    local m = 0
    while true do
        m = m + 1
        if arr[m][mod(-10 ^ m, n) + 1] == 1 then
            break
        end
        arr[m + 1][1] = 1
        for k = 1, n - 1 do
            arr[m + 1][k + 1] = math.max(arr[m][k + 1], arr[m][mod(k - 10 ^ m, n) + 1])
        end
    end
    local r = 10 ^ m
    local k = mod(-r, n)
    for j = m - 1, 1, -1 do
        if arr[j][k + 1] == 0 then
            r = r + 10 ^ j
            k = mod(k - 10 ^ j, n)
        end
    end
    if k == 1 then
        r = r + 1
    end
    return r
end

function test(cases)
    for _,n in ipairs(cases) do
        local result = getA004290(n)
        print(string.format("A004290(%d) = %s = %d * %d", n, math.floor(result), n, math.floor(result / n)))
    end
end

test({1, 2, 3, 4, 5, 6, 7, 8, 9})
test({95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105})
test({297, 576, 594, 891, 909, 999})
--test({1998, 2079, 2251, 2277})
--test({2439, 2997, 4878})
