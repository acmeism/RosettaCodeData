sandpile.__index = sandpile
sandpile.new = function(self, vals)
  local inst = setmetatable({},sandpile)
  inst.cell, inst.dim = {}, #vals
  for r = 1, inst.dim do
    inst.cell[r] = {}
    for c = 1, inst.dim do
      inst.cell[r][c] = vals[r][c]
    end
  end
  return inst
end
sandpile.add = function(self, other)
  local vals = {}
  for r = 1, self.dim do
    vals[r] = {}
    for c = 1, self.dim do
      vals[r][c] = self.cell[r][c] + other.cell[r][c]
    end
  end
  local inst = sandpile:new(vals)
  inst:iter()
  return inst
end

local s1 = sandpile:new{{1,2,0},{2,1,1},{0,1,3}}
local s2 = sandpile:new{{2,1,3},{1,0,1},{0,1,0}}
print("s1 =")  s1:draw()
print("\ns2 =")  s2:draw()
local s1ps2 = s1:add(s2)
print("\ns1 + s2 =")  s1ps2:draw()
local s2ps1 = s2:add(s1)
print("\ns2 + s1 =")  s2ps1:draw()
local topple = sandpile:new{{4,3,3},{3,1,2},{0,2,3}}
print("\ntopple, before =")  topple:draw()
topple:iter()
print("\ntopple, after =")  topple:draw()
local s3 = sandpile:new{{3,3,3},{3,3,3},{3,3,3}}
print("\ns3 =")  s3:draw()
local s3_id = sandpile:new{{2,1,2},{1,0,1},{2,1,2}}
print("\ns3_id =") s3_id:draw()
local s3ps3_id = s3:add(s3_id)
print("\ns3 + s3_id =")  s3ps3_id:draw()
local s3_idps3_id = s3_id:add(s3_id)
print("\ns3_id + s3_id =")  s3_idps3_id:draw()
