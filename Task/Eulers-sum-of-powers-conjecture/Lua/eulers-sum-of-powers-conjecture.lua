-- Fast table search (only works if table values are in order)
function binarySearch (t, n)
    local start, stop, mid = 1, #t
    while start < stop do
        mid = math.floor((start + stop) / 2)
        if n == t[mid] then
            return mid
        elseif n < t[mid] then
            stop = mid - 1
        else
            start = mid + 1
        end
    end
    return nil
end

-- Test Euler's sum of powers conjecture
function euler (limit)
    local pow5, sum = {}
    for i = 1, limit do pow5[i] = i^5 end
    for x0 = 1, limit do
        for x1 = 1, x0 do
            for x2 = 1, x1 do
                for x3 = 1, x2 do
                    sum = pow5[x0] + pow5[x1] + pow5[x2] + pow5[x3]
                    if binarySearch(pow5, sum) then
                        print(x0 .. "^5 + " .. x1 .. "^5 + " .. x2 .. "^5 + " .. x3 .. "^5 = " .. sum^(1/5) .. "^5")
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Main procedure
if euler(249) then
    print("Time taken: " .. os.clock() .. " seconds")
else
    print("Looks like he was right after all...")
end
