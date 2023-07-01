function initArray(n,v)
    local tbl = {}
    for i=1,n do
        table.insert(tbl,v)
    end
    return tbl
end

function initArray2(m,n,v)
    local tbl = {}
    for i=1,m do
        table.insert(tbl,initArray(n,v))
    end
    return tbl
end

supply = {50, 60, 50, 50}
demand = {30, 20, 70, 30, 60}
costs = {
    {16, 16, 13, 22, 17},
    {14, 14, 13, 19, 15},
    {19, 19, 20, 23, 50},
    {50, 12, 50, 15, 11}
}

nRows = table.getn(supply)
nCols = table.getn(demand)

rowDone = initArray(nRows, false)
colDone = initArray(nCols, false)
results = initArray2(nRows, nCols, 0)

function diff(j,le,isRow)
    local min1 = 100000000
    local min2 = min1
    local minP = -1
    for i=1,le do
        local done = false
        if isRow then
            done = colDone[i]
        else
            done = rowDone[i]
        end
        if not done then
            local c = 0
            if isRow then
                c = costs[j][i]
            else
                c = costs[i][j]
            end
            if c < min1 then
                min2 = min1
                min1 = c
                minP = i
            elseif c < min2 then
                min2 = c
            end
        end
    end
    return {min2 - min1, min1, minP}
end

function maxPenalty(len1,len2,isRow)
    local md = -100000000
    local pc = -1
    local pm = -1
    local mc = -1

    for i=1,len1 do
        local done = false
        if isRow then
            done = rowDone[i]
        else
            done = colDone[i]
        end
        if not done then
            local res = diff(i, len2, isRow)
            if res[1] > md then
                md = res[1] -- max diff
                pm = i      -- pos of max diff
                mc = res[2] -- min cost
                pc = res[3] -- pos of min cost
            end
        end
    end

    if isRow then
        return {pm, pc, mc, md}
    else
        return {pc, pm, mc, md}
    end
end

function nextCell()
    local res1 = maxPenalty(nRows, nCols, true)
    local res2 = maxPenalty(nCols, nRows, false)
    if res1[4] == res2[4] then
        if res1[3] < res2[3] then
            return res1
        else
            return res2
        end
    else
        if res1[4] > res2[4] then
            return res2
        else
            return res1
        end
    end
end

function main()
    local supplyLeft = 0
    for i,v in pairs(supply) do
        supplyLeft = supplyLeft + v
    end
    local totalCost = 0
    while supplyLeft > 0 do
        local cell = nextCell()
        local r = cell[1]
        local c = cell[2]
        local q = math.min(demand[c], supply[r])
        demand[c] = demand[c] - q
        if demand[c] == 0 then
            colDone[c] = true
        end
        supply[r] = supply[r] - q
        if supply[r] == 0 then
            rowDone[r] = true
        end
        results[r][c] = q
        supplyLeft = supplyLeft - q
        totalCost = totalCost + q * costs[r][c]
    end

    print("    A   B   C   D   E")
    local labels = {'W','X','Y','Z'}
    for i,r in pairs(results) do
        io.write(labels[i])
        for j,c in pairs(r) do
            io.write(string.format("  %2d", c))
        end
        print()
    end
    print("Total Cost = " .. totalCost)
end

main()
