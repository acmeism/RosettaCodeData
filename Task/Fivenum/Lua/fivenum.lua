function slice(tbl, low, high)
    local copy = {}

    for i=low or 1, high or #tbl do
        copy[#copy+1] = tbl[i]
    end

    return copy
end

-- assumes that tbl is sorted
function median(tbl)
    m = math.floor(#tbl / 2) + 1
    if #tbl % 2 == 1 then
        return tbl[m]
    end
    return (tbl[m-1] + tbl[m]) / 2
end

function fivenum(tbl)
    table.sort(tbl)

    r0 = tbl[1]
    r2 = median(tbl)
    r4 = tbl[#tbl]

    m = math.floor(#tbl / 2)
    if #tbl % 2 == 1 then
        low = m
    else
        low = m - 1
    end
    r1 = median(slice(tbl, nil, low+1))
    r3 = median(slice(tbl, low+2, nil))

    return r0, r1, r2, r3, r4
end

x1 = {
    {15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0},
    {36.0, 40.0, 7.0, 39.0, 41.0, 15.0},
    {
        0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
       -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
       -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
        0.75775634,  0.32566578
    }
}

for i,x in ipairs(x1) do
    print(fivenum(x))
end
