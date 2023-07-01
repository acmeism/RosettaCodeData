AVL={balance=0}
AVL.__mt={__index = AVL}


function AVL:new(list)
  local o={}
  setmetatable(o, AVL.__mt)
  for _,v in ipairs(list or {}) do
    o=o:insert(v)
  end
  return o
end

function AVL:rebalance()
  local rotated=false
  if self.balance>1 then
    if self.right.balance<0 then
      self.right, self.right.left.right, self.right.left = self.right.left, self.right, self.right.left.right
      self.right.right.balance=self.right.balance>-1 and 0 or 1
      self.right.balance=self.right.balance>0 and 2 or 1
    end
    self, self.right.left, self.right = self.right, self, self.right.left
    self.left.balance=1-self.balance
    self.balance=self.balance==0 and -1 or 0
    rotated=true
  elseif self.balance<-1 then
    if self.left.balance>0 then
      self.left, self.left.right.left, self.left.right = self.left.right, self.left, self.left.right.left
      self.left.left.balance=self.left.balance<1 and 0 or -1
      self.left.balance=self.left.balance<0 and -2 or -1
    end
    self, self.left.right, self.left = self.left, self, self.left.right
    self.right.balance=-1-self.balance
    self.balance=self.balance==0 and 1 or 0
    rotated=true
  end
  return self,rotated
end

function AVL:insert(v)
  if not self.value then
    self.value=v
    self.balance=0
    return self,1
  end
  local grow
  if v==self.value then
    return self,0
  elseif v<self.value then
    if not self.left then self.left=self:new() end
    self.left,grow=self.left:insert(v)
    self.balance=self.balance-grow
  else
    if not self.right then self.right=self:new() end
    self.right,grow=self.right:insert(v)
    self.balance=self.balance+grow
  end
  self,rotated=self:rebalance()
  return self, (rotated or self.balance==0) and 0 or grow
end

function AVL:delete_move(dir,other,mul)
  if self[dir] then
    local sb2,v
    self[dir], sb2, v=self[dir]:delete_move(dir,other,mul)
    self.balance=self.balance+sb2*mul
    self,sb2=self:rebalance()
    return self,(sb2 or self.balance==0) and -1 or 0,v
  else
    return self[other],-1,self.value
  end
end

function AVL:delete(v,isSubtree)
  local grow=0
  if v==self.value then
    local v
    if self.balance>0 then
      self.right,grow,v=self.right:delete_move("left","right",-1)
    elseif self.left then
      self.left,grow,v=self.left:delete_move("right","left",1)
      grow=-grow
    else
      return not isSubtree and AVL:new(),-1
    end
    self.value=v
    self.balance=self.balance+grow
  elseif v<self.value and self.left then
    self.left,grow=self.left:delete(v,true)
    self.balance=self.balance-grow
  elseif v>self.value and self.right then
    self.right,grow=self.right:delete(v,true)
    self.balance=self.balance+grow
  else
    return self,0
  end
  self,rotated=self:rebalance()
  return self, grow~=0 and (rotated or self.balance==0) and -1 or 0
end

-- output functions

function AVL:toList(list)
  if not self.value then return {} end
  list=list or {}
  if self.left then self.left:toList(list) end
  list[#list+1]=self.value
  if self.right then self.right:toList(list) end
  return list
end

function AVL:dump(depth)
  if not self.value then return end
  depth=depth or 0
  if self.right then self.right:dump(depth+1) end
  print(string.rep("    ",depth)..self.value.." ("..self.balance..")")
  if self.left then self.left:dump(depth+1) end
end

-- test

local test=AVL:new{1,10,5,15,20,3,5,14,7,13,2,8,3,4,5,10,9,8,7}

test:dump()
print("\ninsert 17:")
test=test:insert(17)
test:dump()
print("\ndelete 10:")
test=test:delete(10)
test:dump()
print("\nlist:")
print(unpack(test:toList()))
