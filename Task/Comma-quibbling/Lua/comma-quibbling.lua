function quibble (strTab)
    local outString, join = "{"
    for strNum = 1, #strTab do
        if strNum == #strTab then
            join = ""
        elseif strNum == #strTab - 1 then
            join = " and "
        else
            join = ", "
        end
        outString = outString .. strTab[strNum] .. join
    end
    return outString .. '}'
end

local testCases = {
    {},
    {"ABC"},
    {"ABC", "DEF"},
    {"ABC", "DEF", "G", "H"}
}
for _, input in pairs(testCases) do print(quibble(input)) end
