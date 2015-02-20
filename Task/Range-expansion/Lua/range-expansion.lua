function range(i, j)
    local t = {}
    for n = i, j, i<j and 1 or -1 do
        t[#t+1] = n
    end
    return t
end

function expand_ranges(rspec)
    local ptn = "([-+]?%d+)%s?-%s?([-+]?%d+)"
    local t = {}

    for v in string.gmatch(rspec, '[^,]+') do
        local s, e = v:match(ptn)

        if s == nil then
            t[#t+1] = tonumber(v)
        else
            for i, n in ipairs(range(tonumber(s), tonumber(e))) do
                t[#t+1] = n
            end
        end
    end
    return t
end

local ranges = "-6,-3--1,3-5,7-11,14,15,17-20"
print(table.concat(expand_ranges(ranges), ', '))
