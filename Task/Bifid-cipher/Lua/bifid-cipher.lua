function transcipher (cipher, message, decipher)
    local message = message:gsub("%s+", ""):upper()
    local xStr, yStr, s, char = "", "", ""
    for pos = 1, #message do
        char = message:sub(pos, pos)
        for x = 1, #cipher do
            for y = 1, #cipher[x] do
                if cipher[x][y] == char then
                    s = s .. x .. y
                    xStr = xStr .. x
                    yStr = yStr .. y
                end
            end
        end
    end
    if decipher then
        xStr, yStr = s:sub(1, #s/2), s:sub(#s/2 + 1, #s)
    else
        s = xStr .. yStr
    end
    local result, x, y = ""
    local limit = decipher and #s/2 or #s
    local step = decipher and 1 or 2
    for pos = 1, limit, step do
        x = tonumber(s:sub(pos, pos))
        y = decipher and
            tonumber(s:sub(pos + #s/2, pos + #s/2)) or
            tonumber(s:sub(pos + 1, pos + 1))
        result = result .. cipher[x][y]
    end
    return result
end

local RCbifid = {
    {"A", "B", "C", "D", "E"},
    {"F", "G", "H", "I", "K"},
    {"L", "M", "N", "O", "P"},
    {"Q", "R", "S", "T", "U"},
    {"V", "W", "X", "Y", "Z"}
}

local wikibifid = {
    {"B", "G", "W", "K", "Z"},
    {"Q", "P", "N", "D", "S"},
    {"I", "O", "A", "X", "E"},
    {"F", "C", "L", "U", "M"},
    {"T", "H", "Y", "V", "R"}
}

local mybifid = {
    {"A", "B", "C", "D", "E", "F"},
    {"G", "H", "I", "J", "K", "L"},
    {"M", "N", "O", "P", "Q", "R"},
    {"S", "T", "U", "V", "W", "X"},
    {"Y", "Z", "1", "2", "3", "4"},
    {"5", "6", "7", "8", "9", "0"}
}

local testCases = {
    {RCbifid, "ATTACKATDAWN"},
    {wikibifid, "FLEEATONCE"},
    {wikibifid, "ATTACKATDAWN",},
    {mybifid, "The invasion will start on the first of January"}
}

local msg
for task, case in pairs(testCases) do
    print("\nTask " .. task)
    msg = transcipher(case[1], case[2])
    print("Encoded message: " .. msg)
    msg = transcipher(case[1], msg, true)
    print("Decoded message: " .. msg)
end
