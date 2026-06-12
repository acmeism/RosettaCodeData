function listdiv(arr, n)
    local L = #arr
    local result = {}

    if n <= 0 then
        print("ValueError: n must be a positive integer.")
        return nil
    end

    if L == 0 then return {} end

    if n > L then
        print("ValueError: n is too large.")
        return nil
    end

    local d = math.floor(L / n)
    local r = L % n
    local i = 1

    for part = 1, n do
        local nextsize = d + (part <= r and 1 or 0)
        local sub = {}

        for k = 1, nextsize do
            table.insert(sub, arr[i])
            i = i + 1
        end

        table.insert(result, sub)
    end

    return result
end

function printList(t)
    if not t then return end
	if #t == 0 then
        print("[]")
        return
    end
    io.write("[")
    for i, sub in ipairs(t) do
        io.write("[")
        for j, v in ipairs(sub) do
            io.write(v)
            if j < #sub then io.write(", ") end
        end
        io.write("]")
        if i < #t then io.write(", ") end
    end
    print("]")
end

-- Tests
printList(listdiv({94,94,13,77,35,10,51,27,60}, 6))
printList(listdiv({19, 46, 43, 17, 94},1))
printList(listdiv({93, 88, 40, 88, 30, 68, 84, 25},3))
printList(listdiv({88, 94, 10, 27, 54, 14},3))
printList(listdiv({31, 19, 63, 57, 57, 74, 50, 14, 38},4))
printList(listdiv({72, 57, 89, 55, 36, 84, 10, 95, 99, 35},7))

print("---- Edge cases ----")
printList(listdiv({23, 49, 57}, 10))
printList(listdiv({1}, 2))
printList(listdiv({}, 2))

print("---- Random tests ----")
math.randomseed(os.time())
for _ = 1, 10 do
    local k = math.random(0, 10)
    local n = math.random(-1, 10)

    local l = {}
    for i = 1, k do
        l[i] = math.random(10, 99)
    end

    io.write("listdiv([")
    for i, v in ipairs(l) do
        io.write(v)
        if i < #l then io.write(", ") end
    end
    io.write("], " .. n .. ") =\n")

    if n < 0 then
        print("  ValueError: n must be a positive integer.")
    else
        local res = listdiv(l, n)
        if res then
            io.write("  ")
            printList(res)
        end
    end
end
print(string.rep("-", 20))
