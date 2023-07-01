-- Global variables
http = require("socket.http")
keys = {"VOICEMAIL", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"}
dictFile = "http://www.puzzlers.org/pub/wordlists/unixdict.txt"

-- Return the sequence of keys required to type a given word
function keySequence (str)
    local sequence, noMatch, letter = ""
    for pos = 1, #str do
        letter = str:sub(pos, pos)
        for i, chars in pairs(keys) do
            noMatch = true
            if chars:match(letter) then
                sequence = sequence .. tostring(i)
                noMatch = false
                break
            end
        end
        if noMatch then return nil end
    end
    return tonumber(sequence)
end

-- Generate table of words grouped by key sequence
function textonyms (dict)
    local combTable, keySeq = {}
    for word in dict:gmatch("%S+") do
        keySeq = keySequence(word)
        if keySeq then
            if combTable[keySeq] then
                table.insert(combTable[keySeq], word)
            else
                combTable[keySeq] = {word}
            end
        end
    end
    return combTable
end

-- Analyse sequence table and print details
function showReport (keySeqs)
    local wordCount, seqCount, tCount = 0, 0, 0
    for seq, wordList in pairs(keySeqs) do
        wordCount = wordCount + #wordList
        seqCount = seqCount + 1
        if #wordList > 1 then tCount = tCount + 1 end
    end
    print("There are " .. wordCount .. " words in " .. dictFile)
    print("which can be represented by the digit key mapping.")
    print("They require " .. seqCount .. " digit combinations to represent them.")
    print(tCount .. " digit combinations represent Textonyms.")
end

-- Main procedure
showReport(textonyms(http.request(dictFile)))
