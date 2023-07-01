function t2s(t)
    local s = "["
    for i,v in pairs(t) do
        if i > 1 then
            s = s .. ", " .. v
        else
            s = s .. v
        end
    end
    return s .. "]"
end

function linearCombo(c)
    local sb = ""
    for i,n in pairs(c) do
        local skip = false

        if n < 0 then
            if sb:len() == 0 then
                sb = sb .. "-"
            else
                sb = sb .. " - "
            end
        elseif n > 0 then
            if sb:len() ~= 0 then
                sb = sb .. " + "
            end
        else
            skip = true
        end

        if not skip then
            local av = math.abs(n)
            if av ~= 1 then
                sb = sb .. av .. "*"
            end
            sb = sb .. "e(" .. i .. ")"
        end
    end
    if sb:len() == 0 then
        sb = "0"
    end
    return sb
end

function main()
    local combos = {
        {  1,  2,  3},
        {  0,  1,  2,  3 },
        {  1,  0,  3,  4 },
        {  1,  2,  0 },
        {  0,  0,  0 },
        {  0 },
        {  1,  1,  1 },
        { -1, -1, -1 },
        { -1, -2, 0, -3 },
        { -1 }
    }

    for i,c in pairs(combos) do
        local arr = t2s(c)
        print(string.format("%15s -> %s", arr, linearCombo(c)))
    end
end

main()
