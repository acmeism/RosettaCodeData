function T(t) return setmetatable(t, {__index=table}) end
table.each = function(t,f) for i=1,#t do f(t[i]) end return t end
table.map = function(t,f) local s=T{} for i=1,#t do s[i]=f(t[i]) end return s end
table.clone = function(t) local s=T{} for k,v in ipairs(t) do s[k]=v end return s end
table.filter = function(t,f) local s=T{} for i=1,#t do if f(t[i]) then s[#s+1]=t[i] end end return s end

function Amb(f, ...)
  local function cartprod(...)
    local sets, temp, prod = {...}, T{}, T{}
    local function descend(depth)
      for k,v in pairs(sets[depth]) do
        temp[depth] = v
        if (depth==#sets) then prod[#prod+1] = temp:clone() else descend(depth+1) end
        temp[depth] = nil
      end
    end
    descend(1)
    return prod
  end
  return type(f)=='function' and cartprod(...):filter(f) or {f,...}
end
