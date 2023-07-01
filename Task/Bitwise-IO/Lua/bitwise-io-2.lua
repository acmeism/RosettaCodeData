-- Test writing.
local writer = BitWriter()
local input  = "Beautiful moon!"

for i = 1, #input do
    writer:writeLsb(input:byte(i), 7)
end

local data = writer:getOutput() -- May include padding at the end.

-- Test reading.
local reader = BitReader(data)
local chars  = {}

for i = 1, #input do -- Assume the amount of characters is the same as when we wrote the data.
    chars[i] = string.char(reader:readLsb(7))
end

local output = table.concat(chars)

-- Show results.
local hexToBin = {["0"]="0000",["1"]="0001",["2"]="0010",["3"]="0011",
                  ["4"]="0100",["5"]="0101",["6"]="0110",["7"]="0111",
                  ["8"]="1000",["9"]="1001",["a"]="1010",["b"]="1011",
                  ["c"]="1100",["d"]="1101",["e"]="1110",["f"]="1111"}
local function charToHex(c)
    return string.format("%02x", c:byte())
end
local function formatBinary(data)
    return (data:gsub(".", charToHex)
                :gsub(".", hexToBin)
                :gsub("........", "%0 "))
end

print("In:   "..input)
print("Out:  "..output)
print("Data: "..formatBinary(data))
