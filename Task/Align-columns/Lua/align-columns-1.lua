local tWord = {}        -- word table
local tColLen = {}      -- maximum word length in a column
local rowCount = 0      -- row counter
--store maximum column lengths at 'tColLen'; save words into 'tWord' table
local function readInput(pStr)
    for line in pStr:gmatch("([^\n]+)[\n]-") do  -- read until '\n' character
        rowCount = rowCount + 1
        tWord[rowCount] = {}                     -- create new row
        local colCount = 0
        for word in line:gmatch("[^$]+") do      -- read non '$' character
            colCount = colCount + 1
            tColLen[colCount] = math.max((tColLen[colCount] or 0), #word)   -- store column length
            tWord[rowCount][colCount] = word                                -- store words
        end--for word
    end--for line
end--readInput
--repeat space to align the words in the same column
local align = {
    ["left"] = function (pWord, pColLen)
        local n = (pColLen or 0) - #pWord + 1
        return pWord .. (" "):rep(n)
    end;--["left"]
    ["right"] = function (pWord, pColLen)
        local n = (pColLen or 0) - #pWord + 1
        return (" "):rep(n) .. pWord
    end;--["right"]
    ["center"] = function (pWord, pColLen)
        local n = (pColLen or 0) - #pWord + 1
        local n1 = math.floor(n/2)
        return (" "):rep(n1) .. pWord .. (" "):rep(n-n1)
    end;--["center"]
}
--word table padder
local function padWordTable(pAlignment)
    local alignFunc = align[pAlignment]                         -- selecting the spacer function
    for rowCount, tRow in ipairs(tWord) do
        for colCount, word in ipairs(tRow) do
            tRow[colCount] = alignFunc(word, tColLen[colCount]) -- save the padded words into the word table
        end--for colCount, word
    end--for rowCount, tRow
end--padWordTable
--main interface
--------------------------------------------------[]
function alignColumn(pStr, pAlignment, pFileName)
--------------------------------------------------[]
    readInput(pStr)                           -- store column lengths and words
    padWordTable(pAlignment or "left")        -- pad the stored words
    local output = ""
    for rowCount, tRow in ipairs(tWord) do
        local line = table.concat(tRow)       -- concatenate words in one row
        print(line)                           -- print the line
        output = output .. line .. "\n"       -- concatenate the line for output, add line break
    end--for rowCount, tRow
    if (type(pFileName) == "string") then
        local file = io.open(pFileName, "w+")
        file:write(output)                    -- write output to file
        file:close()
    end--if type(pFileName)
    return output
end--alignColumn
