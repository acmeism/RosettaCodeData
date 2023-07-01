-- Iterative version
function ipermutations(a,b)
    if a==0 then return end
    local taken = {} local slots = {}
    for i=1,a do slots[i]=0 end
    for i=1,b do taken[i]=false end
    local index = 1
    while index > 0 do repeat
        repeat slots[index] = slots[index] + 1
        until slots[index] > b or not taken[slots[index]]
        if slots[index] > b then
            slots[index] = 0
            index = index - 1
            if index > 0 then
                taken[slots[index]] = false
            end
            break
        else
            taken[slots[index]] = true
        end
        if index == a then
            for i=1,a do io.write(slots[i]) io.write(" ") end
            io.write("\n")
            taken[slots[index]] = false
            break
        end
        index = index + 1
    until true end
end

ipermutations(3, 3)
