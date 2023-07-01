--------------
-- TRAVERSAL:
--------------
List.iterateForward = function(self)
  local function iter(self, node)
    if node then return node.next else return self.head end
  end
  return iter, self, nil
end
List.iterateReverse = function(self)
  local function iter(self, node)
    if node then return node.prev else return self.tail end
  end
  return iter, self, nil
end

---------
-- TEST:
---------
local list = List()
for i = 1, 5 do list:insertTail(i) end
io.write("Forward: ") for node in list:iterateForward() do io.write(node.data..",") end print()
io.write("Reverse: ") for node in list:iterateReverse() do io.write(node.data..",") end print()
