function amb (set)
    local workset = {}
    if (#set == 0) or (type(set) ~= 'table') then return end
    if #set == 1 then return set end
    if #set > 2 then
        local first = table.remove(set,1)
        set = amb(set)
        for i,v in next,first do
            for j,u in next,set do
                if v:byte(#v) == u[1]:byte(1) then table.insert(workset, {v,unpack(u)}) end
            end
        end
        return workset
    end
    for i,v in next,set[1] do
        for j,u in next,set[2] do
            if v:byte(#v) == u:byte(1) then table.insert(workset,{v,u}) end
        end
    end
    return workset
end
