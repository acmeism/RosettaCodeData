local WIDTH = 81
local HEIGHT = 5
local lines = {}

function cantor(start, length, index)
    -- must be local, or only one side will get calculated
    local seg = math.floor(length / 3)
    if 0 == seg then
        return nil
    end

    -- remove elements that are not in the set
    for it=0, HEIGHT - index do
        i = index + it
        for jt=0, seg - 1 do
            j = start + seg + jt
            pos = WIDTH * i + j
            lines[pos] = ' '
        end
    end

    -- left side
    cantor(start,           seg, index + 1)
    -- right side
    cantor(start + seg * 2, seg, index + 1)
    return nil
end

-- initialize the lines
for i=0, WIDTH * HEIGHT do
    lines[i] = '*'
end

-- calculate
cantor(0, WIDTH, 1)

-- print the result sets
for i=0, HEIGHT-1 do
    beg = WIDTH * i
    for j=beg, beg+WIDTH-1 do
        if j <= WIDTH * HEIGHT then
            io.write(lines[j])
        end
    end
    print()
end
