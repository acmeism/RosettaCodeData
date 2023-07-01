on isPangram(txt)
    set alphabet to "abcedfghijklmnopqrstuvwxyz"
    ignoring case -- The default, but ensure it here.
        repeat with letter in alphabet
            if (txt does not contain letter) then return false
        end repeat
    end ignoring

    return true
end isPangram

local result1, result2
set result1 to isPangram("The Quick Brown Fox Jumps Over The Lazy Dog")
set result2 to isPangram("This is not a pangram")
return {result1, result2}
