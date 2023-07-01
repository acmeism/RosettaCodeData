seed = 675248

function rnd ()
    local s = tostring(seed * seed)
    while #s ~= 12 do
        s = "0" .. s
    end
    seed = tonumber(s:sub(4, 9))
    return seed
end

for i = 1, 5 do
    print(rnd())
end
