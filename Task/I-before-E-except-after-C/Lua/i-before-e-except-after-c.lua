-- Needed to get dictionary file from web server
local http = require("socket.http")

-- Return count of words that contain pattern
function count (pattern, wordList)
    local total = 0
    for word in wordList:gmatch("%S+") do
        if word:match(pattern) then total = total + 1 end
    end
    return total
end

-- Check plausibility of case given its opposite
function plaus (case, opposite, words)
    if count(case, words) > 2 * count(opposite, words) then
        print("PLAUSIBLE")
        return true
    else
        print("IMPLAUSIBLE")
        return false
    end
end

-- Main procedure
local page = http.request("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
io.write("I before E when not preceded by C: ")
local sub1 = plaus("[^c]ie", "cie", page)
io.write("E before I when preceded by C: ")
local sub2 = plaus("cei", "[^c]ei", page)
io.write("Overall the phrase is ")
if not (sub1 and sub2) then io.write("not ") end
print("plausible.")
