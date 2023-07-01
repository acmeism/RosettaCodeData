function ASCIIstring (pattern)
    local matchString, ch = ""
    for charNum = 0, 255 do
        ch = string.char(charNum)
        if string.match(ch, pattern) then
            matchString = matchString .. ch
        end
    end
    return matchString
end

print(ASCIIstring("%l"))
print(ASCIIstring("%u"))
