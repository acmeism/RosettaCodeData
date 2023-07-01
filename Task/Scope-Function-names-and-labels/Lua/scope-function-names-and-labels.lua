function foo() print("global") end -- global scope by default
foo()
local function foo() print("local module") end -- local to the current block (which is the module)
foo() -- local obscures the global
_G.foo() -- bug global still exists
do -- create a new block
  foo() -- outer module-level scope still visible
  local function foo() print("local block") end
  foo() -- obscures outer module-level local
  local function foo() -- redefine at local block level
    print("local block redef")
    local function foo() -- define again inside redef
      print("local block redef inner")
    end
    foo() -- call block-level redef inner
  end
  foo() -- call block-level redef
end -- close the block (and thus its scope)
foo() -- module-level local still exists
_G.foo() -- global still exists
