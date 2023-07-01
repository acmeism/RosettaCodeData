function generateGaps(start, count)
    local counter = 0
    local i = start

    print(string.format("First %d Gapful numbers >= %d :", count, start))

    while counter < count do
        local str = tostring(i)
        local denom = 10 * tonumber(str:sub(1, 1)) + (i % 10)
        if i % denom == 0 then
            print(string.format("%3d : %d", counter + 1, i))
            counter = counter + 1
        end
        i = i + 1
    end
end

generateGaps(100, 30)
print()

generateGaps(1000000, 15)
print()

generateGaps(1000000000, 15)
print()
