lfs = require "lfs"

-- This function takes two arguments:
-- - the directory to walk recursively;
-- - an optional function that takes a file name as argument, and returns a boolean.
find = (fn) => coroutine.wrap ->
  for f in lfs.dir @
    if f ~= "." and f ~= ".."
      _f = @.."/"..f
      coroutine.yield _f if not fn or fn _f
      if lfs.attributes(_f, "mode") == "directory"
        coroutine.yield n for n in find _f, fn

-- Examples
-- List all files
print f for f in find "templates"

-- List moonscript files
print f for f in find "templates", => @\match "%.moon$"

-- List directories
print f for f in find "templates", => "directory" == lfs.attributes @, "mode"
