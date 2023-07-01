-- Doubly Linked List in Lua 6/15/2020 db
-------------------
-- IMPLEMENTATION:
-------------------

local function Node(data)
  return { data=data } --implied: return { data=data, prev=nil, next=nil }
end

local List = {
  head = nil,
  tail = nil,
  insertHead = function(self, data)
    local node = Node(data)
    if (self.head) then
      self.head.prev = node
      node.next = self.head
      self.head = node
    else
      self.head = node
      self.tail = node
    end
    return node
  end,
  insertTail = function(self, data)
    local node = Node(data)
    if self.tail then
      self.tail.next = node
      node.prev = self.tail
      self.tail = node
    else
      self.head = node
      self.tail = node
    end
    return node
  end,
  insertBefore = function(self,mark,data)
    if (mark) then
      local node = Node(data)
      if (mark == self.head) then
        self.head.next = node
        node.next = self.head
        self.head = node
      else
        mark.prev.next = node
        node.prev = mark.prev
        mark.prev = node
        node.next = mark
      end
      return node
    else
      -- if no mark given, then insertBefore()==insertHead()
      return self:insertHead(data)
    end
  end,
  insertAfter = function(self,mark,data)
    if (mark) then
      local node = Node(data)
      if (mark == self.tail) then
        self.tail.next = node
        node.prev = self.tail
        self.tail = node
      else
        mark.next.prev = node
        node.next = mark.next
        mark.next = node
        node.prev = mark
      end
      return node
    else
      -- if no mark given, then insertAfter()==insertTail()
      return self:insertTail(data)
    end
  end,
  values = function(self)
    local result, node = {}, self.head
    while (node) do result[#result+1], node = node.data, node.next end
    return result
  end,
}
List.__index = List
setmetatable(List, {__call=function(self) return setmetatable({},self) end })

---------
-- TEST:
---------
local function validate(list, expected)
  local values = list:values()
  local actual = table.concat(values, ",")
  print(actual==expected, actual)
end
local list = List()                      validate(list, "")
local n1   = list:insertTail(1)          validate(list, "1")
local n2   = list:insertTail(2)          validate(list, "1,2")
local n3   = list:insertTail(3)          validate(list, "1,2,3")
local n4   = list:insertTail(4)          validate(list, "1,2,3,4")
local n33  = list:insertAfter(n3, 33)    validate(list, "1,2,3,33,4")
local n22  = list:insertAfter(n2, 22)    validate(list, "1,2,22,3,33,4")
local n11  = list:insertAfter(n1, 11)    validate(list, "1,11,2,22,3,33,4")
local n44  = list:insertAfter(n4, 44)    validate(list, "1,11,2,22,3,33,4,44")
local n5   = list:insertTail(5)          validate(list, "1,11,2,22,3,33,4,44,5")
local n444 = list:insertBefore(n5, 444)  validate(list, "1,11,2,22,3,33,4,44,444,5")
local n55  = list:insertAfter(nil, 55)   validate(list, "1,11,2,22,3,33,4,44,444,5,55")
local n0   = list:insertHead(0)          validate(list, "0,1,11,2,22,3,33,4,44,444,5,55")
local nm1  = list:insertBefore(nil, -1)  validate(list, "-1,0,1,11,2,22,3,33,4,44,444,5,55")
local n111 = list:insertBefore(n2, 111)  validate(list, "-1,0,1,11,111,2,22,3,33,4,44,444,5,55")
local n222 = list:insertAfter(n22, 222)  validate(list, "-1,0,1,11,111,2,22,222,3,33,4,44,444,5,55")
local n333 = list:insertBefore(n4, 333)  validate(list, "-1,0,1,11,111,2,22,222,3,33,333,4,44,444,5,55")
local n555 = list:insertAfter(n55, 555)  validate(list, "-1,0,1,11,111,2,22,222,3,33,333,4,44,444,5,55,555")
