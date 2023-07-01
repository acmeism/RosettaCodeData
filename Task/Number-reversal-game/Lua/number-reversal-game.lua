-- Initialisation
math.randomseed(os.time())
numList = {values = {}}

-- Check whether list contains n
function numList:contains (n)
  for k, v in pairs(self.values) do
    if v == n then return true end
  end
  return false
end

-- Check whether list is in order
function numList:inOrder ()
  for k, v in pairs(self.values) do
    if k ~=v then return false end
  end
  return true
end

-- Create necessarily out-of-order list
function numList:build ()
  local newNum
  repeat
    for i = 1, 9 do
      repeat
        newNum = math.random(1, 9)
      until not numList:contains(newNum)
      table.insert(self.values, newNum)
    end
  until not numList:inOrder()
end

-- Display list of numbers on one line
function numList:show ()
  for k, v in pairs(self.values) do
    io.write(v .. " ")
  end
  io.write(":\t")
end

-- Reverse n values from left
function numList:reverse (n)
  local swapList = {}
  for k, v in pairs(self.values) do
    table.insert(swapList, v)
  end
  for i = 1, n do
    swapList[i] = self.values[n + 1 - i]
  end
  self.values = swapList
end

-- Main procedure
local score = 0
print("\nRosetta Code Number Reversal Game in Lua")
print("========================================\n")
numList:build()
repeat
  numList:show()
  numList:reverse(tonumber(io.read()))
  score = score + 1
until numList:inOrder()
numList:show()
print("\n\nW00t!  You scored:", score)
