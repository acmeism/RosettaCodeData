-- map of character values to desired representation
local chars = setmetatable({[32] = "Spc", [127] = "Del"}, {__index = function(_, k) return string.char(k) end})

-- row iterator
local function iter(s,a)
  a = (a or s) + 16
  if a <= 127 then return a, chars[a] end
end

-- print loop
for i = 0, 15 do
   for j, repr in iter, i+16 do
      io.write(("%3d : %3s    "):format(j, repr))
   end
   io.write"\n"
end
