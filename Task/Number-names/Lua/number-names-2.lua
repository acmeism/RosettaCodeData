-- Number names, in Lua, 6/17/2020 db
local oneslist = { [0]="", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }
local teenlist = { [0]="ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen" }
local tenslist = { [0]="", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" }
local lionlist = { [0]="", "thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion", "octillion", "nonillion", "decillion" }
local abs, floor = math.abs, math.floor

local function numname(num)
  if (num == 0) then return "zero" end
  local absnum, lion, result = abs(num), 0, ""
  local function dashed(s) return s=="" and s or "-"..s end
  local function spaced(s) return s=="" and s or " "..s end
  while (absnum > 0) do
    local word, ones, tens, huns = "", absnum%10, floor(absnum/10)%10, floor(absnum/100)%10
    if (tens==0) then word = oneslist[ones]
    elseif (tens==1) then word = teenlist[ones]
    else word = tenslist[tens] .. dashed(oneslist[ones]) end
    if (huns > 0) then word = oneslist[huns] .. " hundred" .. spaced(word) end
    if (word ~= "") then result = word .. spaced(lionlist[lion]) .. spaced(result) end
    absnum = floor(absnum / 1000)
    lion = lion + 1
  end
  if (num < 0) then result = "negative " .. result end
  return result
end

local numbers = {
  -1, 0, 1,
  10, 15, 20, 21,
  123, 300, 301, 320, 321,
  1e3, 1e3+1, 1010, 1011, 1100, 1101, 1110, 1111, 1234, 4321, 12345, 54321, 123456, 654321,
  1e6, 1e6+1, 1001000, 1234567, 12345678, 123456789, 987654321,
  1e9, 1e9+1, 1000001000, 1001000000, 1001001000, 1234567890, 12345678901, 123456789012, 210987654321,
  1e12, 1e12+1, 1000000001000, 1000001000000, 1000001001000, 1001001001001, 1234567890123, 12345678901234, 123456789012345, 543210987654321,
  1e15, 1e15+1, 1010101010101010, 1234567890123456, 6543210987654321,
  -- limit of precision, pushing it..
  1e18, 1e21,
}
for _, num in ipairs(numbers) do
  print( string.format("%.f:  '%s'", num, numname(num)) )
end
