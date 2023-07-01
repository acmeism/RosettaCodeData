function isHumble(n)
    local n2 = math.floor(n)

    if n2 <= 1 then
        return true
    end
    if n2 % 2 == 0 then
        return isHumble(n2 / 2)
    end
    if n2 % 3 == 0 then
        return isHumble(n2 / 3)
    end
    if n2 % 5 == 0 then
        return isHumble(n2 / 5)
    end
    if n2 % 7 == 0 then
        return isHumble(n2 / 7)
    end

    return false
end

function main()
    local limit = 10000
    local humble = {0, 0, 0, 0, 0, 0, 0, 0, 0}
    local count = 0
    local num = 1

    while count < limit do
        if isHumble(num) then
            local buffer = string.format("%d", num)
            local le = string.len(buffer)
            if le > 9 then
                break
            end
            humble[le] = humble[le] + 1

            if count < 50 then
                io.write(num .. " ")
            end
            count = count + 1
        end
        num = num + 1
    end
    print("\n")

    print("Of the first " .. count .. " humble numbers:")
    for num=1,9 do
        print(string.format("%5d have %d digits", humble[num], num))
    end
end

main()
