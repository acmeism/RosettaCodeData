local c = {
  new = function(s,r,i) s.__index=s return setmetatable({r=r, i=i}, s) end,
  add = function(s,o) return s:new(s.r+o.r, s.i+o.i) end,
  exp = function(s) local e=math.exp(s.r) return s:new(e*math.cos(s.i), e*math.sin(s.i)) end,
  mul = function(s,o) return s:new(s.r*o.r+s.i*o.i, s.r*o.i+s.i*o.r) end
}
local i = c:new(0, 1)
local pi = c:new(math.pi, 0)
local one = c:new(1, 0)
local zero = i:mul(pi):exp():add(one)
print(string.format("e^(i*pi)+1 is approximately zero:  %.18g%+.18gi", zero.r, zero.i))
