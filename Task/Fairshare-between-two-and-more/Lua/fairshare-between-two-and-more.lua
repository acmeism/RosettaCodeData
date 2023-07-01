function turn(base, n)
    local sum = 0
    while n ~= 0 do
        local re = n % base
        n = math.floor(n / base)
        sum = sum + re
    end
    return sum % base
end

function fairShare(base, count)
    io.write(string.format("Base %2d:", base))
    for i=1,count do
        local t = turn(base, i - 1)
        io.write(string.format(" %2d", t))
    end
    print()
end

function turnCount(base, count)
    local cnt = {}

    for i=1,base do
        cnt[i - 1] = 0
    end

    for i=1,count do
        local t = turn(base, i - 1)
        if cnt[t] ~= nil then
            cnt[t] = cnt[t] + 1
        else
            cnt[t] = 1
        end
    end

    local minTurn = count
    local maxTurn = -count
    local portion = 0
    for _,num in pairs(cnt) do
        if num > 0 then
            portion = portion + 1
        end
        if num < minTurn then
            minTurn = num
        end
        if maxTurn < num then
            maxTurn = num
        end
    end

    io.write(string.format("  With %d people: ", base))
    if minTurn == 0 then
        print(string.format("Only %d have a turn", portion))
    elseif minTurn == maxTurn then
        print(minTurn)
    else
        print(minTurn .. " or " .. maxTurn)
    end
end

function main()
    fairShare(2, 25)
    fairShare(3, 25)
    fairShare(5, 25)
    fairShare(11, 25)

    print("How many times does each get a turn in 50000 iterations?")
    turnCount(191, 50000)
    turnCount(1377, 50000)
    turnCount(49999, 50000)
    turnCount(50000, 50000)
    turnCount(50001, 50000)
end

main()
