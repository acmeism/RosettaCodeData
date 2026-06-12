local sixesThrowAgain = true

function rollDice()
    return math.random(6)
end

function nextSquare(square)
    if square == 4 then
        return 14
    elseif square == 9 then
        return 31
    elseif square == 17 then
        return 7
    elseif square == 20 then
        return 38
    elseif square == 28 then
        return 84
    elseif square == 40 then
        return 59
    elseif square == 51 then
        return 67
    elseif square == 54 then
        return 34
    elseif square == 62 then
        return 19
    elseif square == 63 then
        return 81
    elseif square == 64 then
        return 60
    elseif square == 71 then
        return 91
    elseif square == 87 then
        return 24
    elseif square == 93 then
        return 73
    elseif square == 95 then
        return 75
    elseif square == 99 then
        return 78
    else
        return square
    end
end

function turn(player, square)
    while true do
        local roll = rollDice()
        io.write(string.format("Player %d, on square %d, rolls a %d", player, square, roll))
        if square + roll > 100 then
            io.write(" but cannot move.\n")
        else
            square = square + roll
            io.write(string.format(" and moves to square %d\n", square))
            if square == 100 then
                return 100
            end
            local nxt = nextSquare(square)
            if square < nxt then
                io.write(string.format("Yay! Landed on a ladder. Climb up to %d\n", square))
                square = nxt
            elseif nxt < square then
                io.write(string.format("Oops! Landed on a snake. Slither down to %d\n", square))
                square = nxt
            end
        end
        if roll < 6 or not sizexThrowAgain then
            return square
        end
        io.write("Rolled a 6 so roll again.\n")
    end
end

function main()
    local players = {1, 1, 1}

    while true do
        for i=1,3 do
            local ns = turn(i, players[i])
            if ns == 100 then
                io.write(string.format("Player %d wins!\n", i))
                return
            end
            players[i] = ns
            print()
        end
    end
end

main()
