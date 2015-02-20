function longer(s1, s2)
    while true do
        s1 = s1:sub(1, -2)
        s2 = s2:sub(1, -2)
        if s1:find('^$') and not s2:find('^$') then
           return false
        elseif s2:find('^$') then
           return true
        end
    end
end

local output = ''
local longest = ''

for line in io.lines() do
    local islonger = longer(line, longest)
    if islonger and longer(longest, line) then
        output = output .. line .. '\n'
    elseif islonger then
        longest = line
        output = line .. '\n'
    end
end

print(output)
