local lfs = require("lfs")

-- This function takes two arguments:
-- - the directory to walk recursively;
-- - an optional function that takes a file name as argument, and returns a boolean.
function find(self, fn)
  return coroutine.wrap(function()
    for f in lfs.dir(self) do
      if f ~= "." and f ~= ".." then
        local _f = self .. "/" .. f
        if not fn or fn(_f) then
          coroutine.yield(_f)
        end
        if lfs.attributes(_f, "mode") == "directory" then
          for n in find(_f, fn) do
            coroutine.yield(n)
          end
        end
      end
    end
  end)
end

-- Examples
-- List all files and directories
for f in find("directory") do
  print(f)
end

-- List lua files
for f in find("directory", function(self) return self:match("%.lua$") end) do
  print(f)
end

-- List directories
for f in find("directory", function(self) return "directory" == lfs.attributes(self, "mode") end) do
  print(f)
end
