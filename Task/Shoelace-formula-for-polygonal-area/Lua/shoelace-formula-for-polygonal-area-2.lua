function shoeArea(ps)
  local function ssum(acc, p1, p2, ...)
    if not p2 or not p1 then
      return math.abs(0.5 * acc)
    else
      return ssum(acc + p1[1]*p2[2]-p1[2]*p2[1], p2, ...)
    end
  end
  return ssum(0, ps[#ps], table.unpack(ps))
end

local p = {{3,4}, {5,11}, {12,8}, {9,5}, {5,6}}
print(shoeArea(p))-- 30
