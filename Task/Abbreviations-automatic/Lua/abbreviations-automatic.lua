function split(line)
    local wa = {}
    for i in string.gmatch(line, "%S+") do
        table.insert(wa, i)
    end
    return wa
end

-- main
local file = assert(io.open("days_of_week.txt", "r"))
io.input(file)

local line_num = 0
while true do
    local line = io.read()
    if line == nil then break end
    line_num = line_num + 1

    if string.len(line) > 0 then
        local days = split(line)
        if #days ~= 7 then
            error("There aren't 7 days in line "..line_num)
        end

        local temp = {}
        for i,day in pairs(days) do
            if temp[day] ~= nil then
                io.stderr:write(" ∞  "..line.."\n")
            else
                temp[day] = true
            end
        end

        local length = 1
        while length < 50 do
            temp = {}
            local count = 0
            for i,day in pairs(days) do
                local key = string.sub(day, 0, length)
                if temp[key] ~= nil then break end
                temp[key] = true
                count = count + 1
            end
            if count == 7 then
                print(string.format("%2d  %s", length, line))
                break
            end
            length = length + 1
        end
    end
end
