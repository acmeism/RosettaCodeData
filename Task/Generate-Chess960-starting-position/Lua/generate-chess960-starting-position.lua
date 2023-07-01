-- Insert 'str' into 't' at a random position from 'left' to 'right'
function randomInsert (t, str, left, right)
    local pos
    repeat pos = math.random(left, right) until not t[pos]
    t[pos] = str
    return pos
end

-- Generate a random Chess960 start position for white major pieces
function chess960 ()
    local t, b1, b2 = {}
    local kingPos = randomInsert(t, "K", 2, 7)
    randomInsert(t, "R", 1, kingPos - 1)
    randomInsert(t, "R", kingPos + 1, 8)
    b1 = randomInsert(t, "B", 1, 8)
    b2 = randomInsert(t, "B", 1, 8)
    while (b2 - b1) % 2 == 0 do
        t[b2] = false
        b2 = randomInsert(t, "B", 1, 8)
    end
    randomInsert(t, "Q", 1, 8)
    randomInsert(t, "N", 1, 8)
    randomInsert(t, "N", 1, 8)
    return t
end

-- Main procedure
math.randomseed(os.time())
print(table.concat(chess960()))
