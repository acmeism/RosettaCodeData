function array1D(w, d)
    local t = {}
    for i=1,w do
        table.insert(t, d)
    end
    return t
end

function array2D(h, w, d)
    local t = {}
    for i=1,h do
        table.insert(t, array1D(w, d))
    end
    return t
end

function push(s, v)
    s[#s + 1] = v
end

function pop(s)
    return table.remove(s, #s)
end

function empty(s)
    return #s == 0
end

DIRS = {
    {0, -1},
    {-1, 0},
    {0, 1},
    {1, 0}
}

function printResult(aa)
    for i,u in pairs(aa) do
        io.write("[")
        for j,v in pairs(u) do
            if j > 1 then
                io.write(", ")
            end
            io.write(v)
        end
        print("]")
    end
end

function cutRectangle(w, h)
    if w % 2 == 1 and h % 2 == 1 then
        return nil
    end

    local grid = array2D(h, w, 0)
    local stack = {}

    local half = math.floor((w * h) / 2)
    local bits = 2 ^ half - 1

    while bits > 0 do
        for i=1,half do
            local r = math.floor((i - 1) / w)
            local c = (i - 1) % w
            if (bits & (1 << (i - 1))) ~= 0 then
                grid[r + 1][c + 1] = 1
            else
                grid[r + 1][c + 1] = 0
            end
            grid[h - r][w - c] = 1 - grid[r + 1][c + 1]
        end

        push(stack, 0)
        grid[1][1] = 2
        local count = 1
        while not empty(stack) do
            local pos = pop(stack)

            local r = math.floor(pos / w)
            local c = pos % w

            for i,dir in pairs(DIRS) do
                local nextR = r + dir[1]
                local nextC = c + dir[2]

                if nextR >= 0 and nextR < h and nextC >= 0 and nextC < w then
                    if grid[nextR + 1][nextC + 1] == 1 then
                        push(stack, nextR * w + nextC)
                        grid[nextR + 1][nextC + 1] = 2
                        count = count + 1
                    end
                end
            end
        end
        if count == half then
            printResult(grid)
            print()
        end

        -- loop end
        bits = bits - 2
    end
end

cutRectangle(2, 2)
cutRectangle(4, 3)
