-- Grab luhn function from https://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Lua

local function ToBase36(char) return tonumber(char, 36) end
local function Isin2CCN(isin) return isin:gsub(".", ToBase36) end
local isinPattern = "^%u%u" .. ("[%d%u]"):rep(9) .. "%d$"

function checkISIN (isin)
 return isin:match(isinPattern) and luhn(Isin2CCN(isin)) or false
end

local testCases = {
    "US0378331005",
    "US0373831005",
    "US0373831005",
    "US03378331005",
    "AU0000XVGZA3",
    "AU0000VXGZA3",
    "FR0000988040"
}
for _, ISIN in pairs(testCases) do print(ISIN, checkISIN(ISIN)) end
