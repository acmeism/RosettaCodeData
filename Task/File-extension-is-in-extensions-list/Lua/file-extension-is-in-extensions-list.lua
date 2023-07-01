-- Data declarations
local extentions = {"zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"}
local testCases = {
  "MyData.a##",
  "MyData.tar.Gz",
  "MyData.gzip",
  "MyData.7z.backup",
  "MyData...",
  "MyData",
  "MyData_v1.0.tar.bz2",
  "MyData_v1.0.bz2"
}

-- Return boolean of whether example has a file extension found in extList
function extMatch (extList, example)
  for _, extension in pairs(extList) do
    if example:lower():match("%." .. extension:lower() .. "$") then
      return true
    end
  end
  return false
end

-- Main procedure
for _, case in pairs(testCases) do
  print(case .. ": " .. tostring(extMatch(extentions, case)))
end
