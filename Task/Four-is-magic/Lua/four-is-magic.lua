-- Four is magic, in Lua, 6/16/2020 db
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

local function fourismagic(num)
  local function fim(num)
    local name = numname(num)
    if (num == 4) then
      return name .. " is magic."
    else
      local what = numname(#name)
      return name .. " is " .. what .. ", " .. fim(#name)
    end
  end
  local result = fim(num):gsub("^%l", string.upper)
  return result
end

local numbers = { -21,-1, 0,1,2,3,4,5,6,7,8,9, 12,34,123,456,1024,1234,12345,123456,1010101 }
for _, num in ipairs(numbers) do
  print(num, fourismagic(num))
end
