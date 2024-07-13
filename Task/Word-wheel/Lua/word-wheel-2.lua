-- Algorithm is from Ruby implementation.
local wheel = arg[1] or 'ndeoKgelw' -- wheel is 1st argument
wheel = wheel:lower()
local middle = wheel:sub(5, 5)
assert(#middle == 1)
for line in io.lines() do  -- get dictionary from standard input
    local word = line:lower()
    if word:find(middle) and #word >= 3 then
        for wheel_char in wheel:gmatch('.') do
            word = word:gsub(wheel_char, '', 1)
        end  -- for
        if #word == 0 then io.write(line:lower() .. ' ') end
    end  -- if
end  -- for
print ''
