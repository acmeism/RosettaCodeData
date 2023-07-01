local function Delegator()
  return {
    operation = function(self)
      if (type(self.delegate)=="table") and (type(self.delegate.thing)=="function") then
        return self.delegate:thing()
      else
        return "default implementation"
      end
    end
  }
end

local function Delegate()
  return {
    thing = function(self)
      return "delegate implementation"
    end
  }
end

local function NonDelegate(which)
  if (which == 1) then return true -- boolean
  elseif (which == 2) then return 12345 -- number
  elseif (which == 3) then return "Hello" -- string
  elseif (which == 4) then return function() end -- function
  elseif (which == 5) then return { nothing = function() end } -- table (without "thing")
  elseif (which == 6) then return coroutine.create(function() end) -- thread
  elseif (which == 7) then return io.open("delegates.lua","r") -- userdata (if exists, or nil)
  end
end

-- WITH NO (NIL) DELEGATE
local d = Delegator()
assert(d:operation() == "default implementation")

-- WITH A NON-DELEGATE
for i = 1, 7 do
  d.delegate = NonDelegate(i)
  assert(d:operation() == "default implementation")
end

-- WITH A PROPER DELEGATE
d.delegate = Delegate()
assert(d:operation() == "delegate implementation")

print("pass")
