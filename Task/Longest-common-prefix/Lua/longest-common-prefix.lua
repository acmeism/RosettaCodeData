function lcp (strList)
    local shortest, prefix, first = math.huge, ""
    for _, str in pairs(strList) do
        if str:len() < shortest then shortest = str:len() end
    end
    for strPos = 1, shortest do
        if strList[1] then
            first = strList[1]:sub(strPos, strPos)
        else
            return prefix
        end
        for listPos = 2, #strList do
            if strList[listPos]:sub(strPos, strPos) ~= first then
                return prefix
            end
        end
        prefix = prefix .. first
    end
    return prefix
end

local testCases, pre = {
    {"interspecies", "interstellar", "interstate"},
    {"throne", "throne"},
    {"throne", "dungeon"},
    {"throne", "", "throne"},
    {"cheese"},
    {""},
    {nil},
    {"prefix", "suffix"},
    {"foo", "foobar"}
}
for _, stringList in pairs(testCases) do
    pre = lcp(stringList)
    if pre == "" then print(string.char(238)) else print(pre) end
end
