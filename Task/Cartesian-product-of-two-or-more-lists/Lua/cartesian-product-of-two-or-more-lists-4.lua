-- support:
function T(t) return setmetatable(t, {__index=table}) end
table.clone = function(t) local s=T{} for k,v in ipairs(t) do s[k]=v end return s end
table.reduce = function(t,f,acc) for i=1,#t do acc=f(t[i],acc) end return acc end

-- implementation:
local function cartprod(sets)
  local temp, prod = T{}, T{}
  local function descend(depth)
    for _,v in ipairs(sets[depth]) do
      temp[depth] = v
      if (depth==#sets) then prod[#prod+1]=temp:clone() else descend(depth+1) end
    end
  end
  descend(1)
  return prod
end

-- demonstration:
tests = {
  { {1, 2}, {3, 4} },
  { {3, 4}, {1, 2} },
  { {1, 2}, {} },
  { {}, {1, 2} },
  { {1776, 1789}, {7, 12}, {4, 14, 23}, {0, 1} },
  { {1, 2, 3}, {30}, {500, 100} },
  { {1, 2, 3}, {}, {500, 100} }
}
for _,test in ipairs(tests) do
  local cp = cartprod(test)
  print("{"..cp:reduce(function(t,a) return (a=="" and a or a..", ").."("..t:concat(", ")..")" end,"").."}")
end
