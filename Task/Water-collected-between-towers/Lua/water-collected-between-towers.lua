function waterCollected(i,tower)
    local length = 0
    for _ in pairs(tower) do
        length = length + 1
    end

    local wu = 0
    repeat
        local rht = length - 1
        while rht >= 0 do
            if tower[rht + 1] > 0 then
                break
            end
            rht = rht - 1
        end
        if rht < 0 then
            break
        end

        local bof = 0
        local col = 0
        while col <= rht do
            if tower[col + 1] > 0 then
                tower[col + 1] = tower[col + 1] - 1
                bof = bof + 1
            elseif bof > 0 then
                wu = wu + 1
            end
            col = col + 1
        end
        if bof < 2 then
            break
        end
    until false
    if wu == 0 then
        print(string.format("Block %d does not hold any water.", i))
    else
        print(string.format("Block %d holds %d water units.", i, wu))
    end
end

function main()
    local towers = {
        {1, 5, 3, 7, 2},
        {5, 3, 7, 2, 6, 4, 5, 9, 1, 2},
        {2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1},
        {5, 5, 5, 5},
        {5, 6, 7, 8},
        {8, 7, 7, 6},
        {6, 7, 10, 7, 6}
    }

    for i,tbl in pairs(towers) do
        waterCollected(i,tbl)
    end
end

main()
