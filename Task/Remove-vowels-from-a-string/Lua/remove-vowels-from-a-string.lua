function removeVowels (inStr)
    local outStr, letter = ""
    local vowels = "AEIUOaeiou"
    for pos = 1, #inStr do
        letter = inStr:sub(pos, pos)
        if vowels:find(letter) then
            -- This letter is a vowel
        else
            outStr = outStr .. letter
        end
    end
    return outStr
end

local testStr = "The quick brown fox jumps over the lazy dog"
print(removeVowels(testStr))
