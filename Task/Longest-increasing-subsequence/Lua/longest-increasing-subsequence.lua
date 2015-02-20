function buildLIS(seq)
    local piles = { { {table.remove(seq, 1), nil} } }
    while #seq>0 do
        local x=table.remove(seq, 1)
        for j=1,#piles do
            if piles[j][#piles[j]][1]>x then
                table.insert(piles[j], {x, (piles[j-1] and #piles[j-1])})
                break
            elseif j==#piles then
                table.insert(piles, {{x, #piles[j]}})
            end
        end
    end
    local t={}
    table.insert(t, piles[#piles][1][1])
    local p=piles[#piles][1][2]
    for i=#piles-1,1,-1 do
        table.insert(t, piles[i][p][1])
        p=piles[i][p][2]
    end
    table.sort(t)
    print(unpack(t))
end

buildLIS({3,2,6,4,5,1})
buildLIS({0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15})
