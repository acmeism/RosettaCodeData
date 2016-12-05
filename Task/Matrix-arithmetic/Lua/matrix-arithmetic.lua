-- Johnson–Trotter permutations generator
_JT={}
function JT(dim)
  local n={ values={}, positions={}, directions={}, sign=1 }
  setmetatable(n,{__index=_JT})
  for i=1,dim do
    n.values[i]=i
    n.positions[i]=i
    n.directions[i]=-1
  end
  return n
end

function _JT:largestMobile()
  for i=#self.values,1,-1 do
    local loc=self.positions[i]+self.directions[i]
    if loc >= 1 and loc <= #self.values and self.values[loc] < i then
      return i
    end
  end
  return 0
end

function _JT:next()
  local r=self:largestMobile()
  if r==0 then return false end
  local rloc=self.positions[r]
  local lloc=rloc+self.directions[r]
  local l=self.values[lloc]
  self.values[lloc],self.values[rloc] = self.values[rloc],self.values[lloc]
  self.positions[l],self.positions[r] = self.positions[r],self.positions[l]
  self.sign=-self.sign
  for i=r+1,#self.directions do self.directions[i]=-self.directions[i] end
  return true
end

-- matrix class

_MTX={}
function MTX(matrix)
  setmetatable(matrix,{__index=_MTX})
  matrix.rows=#matrix
  matrix.cols=#matrix[1]
  return matrix
end

function _MTX:dump()
  for _,r in ipairs(self) do
    print(unpack(r))
  end
end

function _MTX:perm() return self:det(1) end
function _MTX:det(perm)
  local det=0
  local jt=JT(self.cols)
  repeat
    local pi=perm or jt.sign
    for i,v in ipairs(jt.values) do
      pi=pi*self[i][v]
    end
    det=det+pi
  until not jt:next()
  return det
end

-- test

matrix=MTX
{
  { 7,  2, -2,  4},
  { 4,  4,  1,  7},
  {11, -8,  9, 10},
  {10,  5, 12, 13}
}
matrix:dump();
print("det:",matrix:det(), "permanent:",matrix:perm(),"\n")

matrix2=MTX
{
  {-2, 2,-3},
  {-1, 1, 3},
  { 2, 0,-1}
}
matrix2:dump();
print("det:",matrix2:det(), "permanent:",matrix2:perm())
