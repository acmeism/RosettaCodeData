function gcd(a, b)
    if b == 0 then
        return a
    end
    return gcd(b, a % b)
end

function printArray(a)
    io.write('[')
    for i,v in pairs(a) do
        if i > 1 then
            io.write(', ')
        end
        io.write(v)
    end
    io.write(']')
    return nil
end

function removeAt(a, i)
    local na = {}
    for j,v in pairs(a) do
        if j ~= i then
            table.insert(na, v)
        end
    end
    return na
end

function yellowstone(sequenceCount)
    local yellow = {1, 2, 3}
    local num = 4
    local notYellow = {}
    local yellowSize = 3
    while yellowSize < sequenceCount do
        local found = -1
        for i,test in pairs(notYellow) do
            if gcd(yellow[yellowSize - 1], test) > 1 and gcd(yellow[yellowSize - 0], test) == 1 then
                found = i
                break
            end
        end
        if found >= 0 then
            table.insert(yellow, notYellow[found])
            notYellow = removeAt(notYellow, found)
            yellowSize = yellowSize + 1
        else
            while true do
                if gcd(yellow[yellowSize - 1], num) > 1 and gcd(yellow[yellowSize - 0], num) == 1 then
                    table.insert(yellow, num)
                    yellowSize = yellowSize + 1
                    num = num + 1
                    break
                end
                table.insert(notYellow, num)
                num = num + 1
            end
        end
    end
    return yellow
end

function main()
    print("First 30 values in the yellowstone sequence:")
    printArray(yellowstone(30))
    print()
end

main()
