foo = "global" -- global scope
print(foo)
local foo = "local module" -- local to the current block (which is the module)
print(foo) -- local obscures the global
print(_G.foo) -- but global still exists
do -- create a new block
  print(foo) -- outer module-level scope still visible
  local foo = "local block" -- local to the current block (which is this "do")
  print(foo) -- obscures outer module-level local
  for foo = 1,2 do -- create another more-inner scope
    print("local for "..foo) -- obscures prior block-level local
  end -- and close the scope
  print(foo) -- prior block-level local still exists
end -- close the block (and thus its scope)
print(foo) -- module-level local still exists
print(_G.foo) -- global still exists
