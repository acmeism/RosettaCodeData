function Tokenize (str, sep, esc)
    local strList, word, escaped, ch = {}, "", false
    for pos = 1, #str do
        ch = str:sub(pos, pos)
        if ch == esc then
            if escaped then
                word = word .. ch
            end
            escaped = not escaped
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
