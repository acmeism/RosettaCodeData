-- Return entire contents of named file
function readFile (filename)
  local file = assert(io.open(filename, "r"))
  local contents = file:read("*all")
  file:close()
  return contents
end

-- Return a closure to keep track of letter counts
function tally ()
  local t = {}

  -- Add x to tally if supplied, return tally list otherwise
  local function count (x)
    if x then
      if t[x] then
        t[x] = t[x] + 1
      else
        t[x] = 1
      end
    else
      return t
    end
  end

  return count
end

-- Main procedure
local letterCount = tally()
for letter in readFile(arg[1]):gmatch("%a") do
  letterCount(letter)
end
for k, v in pairs(letterCount()) do
  print(k, v)
end
