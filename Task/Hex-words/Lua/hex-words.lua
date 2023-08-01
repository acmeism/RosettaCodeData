-- Import http namespace from socket library
http = require("socket.http")

-- Download the page at url and return as string
function getFromWeb (url)
    local body, statusCode, headers, statusText = http.request(url)
    if statusCode == 200 then
        return body
    else
        error(statusText)
    end
end

-- Return a boolean to show whether word is a hexword
function isHexWord (word)
    local hexLetters, ch = "abcdef"
    for pos = 1, #word do
        ch = word:sub(pos, pos)
        if not string.find(hexLetters, ch) then return false end
    end
    return true
end

-- Return the sum of the digits in num
function sumDigits (num)
    local sum, nStr, digit = 0, tostring(num)
    for pos = 1, #nStr do
        digit = tonumber(nStr:sub(pos, pos))
        sum = sum + digit
    end
    return sum
end

-- Return the digital root of x
function digitalRoot (x)
    while x > 9 do
        x = sumDigits(x)
    end
    return x
end

-- Return a table from built from the lines of the string dct
-- Each table entry contains the digital root, word and base 10 conversion
function buildTable (dct)
    local t, base10 = {}
    for line in dct:gmatch("[^\n]+") do
        if # line > 3 and isHexWord(line) then
            base10 = (tonumber(line, 16))
            table.insert(t, {digitalRoot(base10), line, base10})
        end
    end
    table.sort(t, function (a,b) return a[1] < b[1] end)
    return t
end

-- Return a boolean to show whether str has at least 4 distinct characters
function fourDistinct (str)
    local distinct, ch = ""
    for pos = 1, #str do
        ch = str:sub(pos, pos)
        if not string.match(distinct, ch) then
            distinct = distinct .. ch
        end
    end
    return #distinct > 3
end

-- Unpack each entry in t and print to the screen
function showTable (t)
    print("\n\nRoot\tWord\tBase 10")
    print("====\t====\t=======")
    for i, v in ipairs(t) do
        print(unpack(v))
    end
    print("\nTable length: " .. #t)
end

-- Main procedure
local dict = getFromWeb("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
local hexWords = buildTable(dict)
showTable(hexWords)
local hexWords2 = {}
for k, v in pairs(hexWords) do
    if fourDistinct(v[2]) then
        table.insert(hexWords2, v)
    end
end
table.sort(hexWords2, function (a, b) return a[3] > b[3] end)
showTable(hexWords2)
