-- Return table of the alphabet in lower case
function getAlphabet ()
    local letters = {}
    for ascii = 97, 122 do table.insert(letters, string.char(ascii)) end
    return letters
end

-- Move the table value at ind to the front of tab
function moveToFront (tab, ind)
    local toMove = tab[ind]
    for i = ind - 1, 1, -1 do tab[i + 1] = tab[i] end
    tab[1] = toMove
end

-- Perform move-to-front encoding on input
function encode (input)
    local symbolTable, output, index = getAlphabet(), {}
    for pos = 1, #input do
        for k, v in pairs(symbolTable) do
            if v == input:sub(pos, pos) then index = k end
        end
        moveToFront(symbolTable, index)
        table.insert(output, index - 1)
    end
    return table.concat(output, " ")
end

-- Perform move-to-front decoding on input
function decode (input)
    local symbolTable, output = getAlphabet(), ""
    for num in input:gmatch("%d+") do
        output = output .. symbolTable[num + 1]
        moveToFront(symbolTable, num + 1)
    end
    return output
end

-- Main procedure
local testCases, output = {"broood", "bananaaa", "hiphophiphop"}
for _, case in pairs(testCases) do
    output = encode(case)
    print("Original string: " .. case)
    print("Encoded: " .. output)
    print("Decoded: " .. decode(output))
    print()
end
