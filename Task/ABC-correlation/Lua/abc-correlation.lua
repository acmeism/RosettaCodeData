require "io"

local function get_count(string)
    local map = {}

    map['a'] = 0
    map['b'] = 0
    map['c'] = 0

    for i=1, #string do
        local c = string:sub(i,i)
        if c == 'a' or c == 'b' or c == 'c' then
            local count = map[c]
            count = count + 1
            map[c] = count
        end
    end
    return map
end


io.write("String with abc: ")

local str = io.read()
local map = get_count(str)

local res = true

for k, v in pairs(map) do
    print(k, v)
end

local count = map['a']
map.a = nil

for _, v in pairs(map) do
    if v ~= count then
        res = false
        break
    end
end

print(res)
