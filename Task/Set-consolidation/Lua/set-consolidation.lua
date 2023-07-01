-- SUPPORT:
function T(t) return setmetatable(t, {__index=table}) end
function S(t) local s=T{} for k,v in ipairs(t) do s[v]=v end return s end
table.each = function(t,f,...) for _,v in pairs(t) do f(v,...) end end
table.copy = function(t) local s=T{} for k,v in pairs(t) do s[k]=v end return s end
table.keys = function(t) local s=T{} for k,_ in pairs(t) do s[#s+1]=k end return s end
table.intersects = function(t1,t2) for k,_ in pairs(t1) do if t2[k] then return true end end return false end
table.union = function(t1,t2) local s=t1:copy() for k,_ in pairs(t2) do s[k]=k end return s end
table.dump = function(t) print('{ '..table.concat(t, ', ')..' }') end

-- TASK:
table.consolidate = function(t)
  for a = #t, 1, -1 do
    local seta = t[a]
    for b = #t, a+1, -1 do
      local setb = t[b]
      if setb and seta:intersects(setb) then
        t[a], t[b] = seta:union(setb), nil
      end
    end
  end
  return t
end

-- TESTING:
examples = {
  T{ S{"A","B"}, S{"C","D"} },
  T{ S{"A","B"}, S{"B","D"} },
  T{ S{"A","B"}, S{"C","D"}, S{"D","B"} },
  T{ S{"H","I","K"}, S{"A","B"}, S{"C","D"}, S{"D","B"}, S{"F","G","H"} },
}
for i,example in ipairs(examples) do
  print("Given input sets:")
  example:each(function(set) set:keys():dump() end)
  print("Consolidated output sets:")
  example:consolidate():each(function(set) set:keys():dump() end)
  print("")
end
