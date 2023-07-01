function isInt (x) return type(x) == "number" and x == math.floor(x) end

print("Value\tInteger?")
print("=====\t========")
local testCases = {2, 0, -1, 3.5, "String!", true}
for _, input in pairs(testCases) do print(input, isInt(input)) end
