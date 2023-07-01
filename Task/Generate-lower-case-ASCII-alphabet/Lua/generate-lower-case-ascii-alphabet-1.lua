function getAlphabet ()
    local letters = {}
    for ascii = 97, 122 do table.insert(letters, string.char(ascii)) end
    return letters
end

local alpha = getAlphabet()
print(alpha[25] .. alpha[1] .. alpha[25])
