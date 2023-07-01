function tokenise (str, sep, esc)
    local strList, word, escaped, ch = {}, "", false
    for pos = 1, #str do
        ch = str:sub(pos, pos)
        if ch == esc then
            if escaped then
                word = word .. ch
                escaped = false
            else
                escaped = true
            end
        elseif ch == sep then
            if escaped then
                word = word .. ch
                escaped = false
            else
                table.insert(strList, word)
                word = ""
            end
        else
            escaped = false
            word = word .. ch
        end
    end
    table.insert(strList, word)
    return strList
end

local testStr = "one^|uno||three^^^^|four^^^|^cuatro|"
local testSep, testEsc = "|", "^"
for k, v in pairs(tokenise(testStr, testSep, testEsc)) do
    print(k, v)
end
