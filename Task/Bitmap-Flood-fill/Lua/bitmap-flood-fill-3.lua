function Bitmap:floodfill(x, y, c)
  local b = self:get(x, y)
  if not b then return end
  local function matches(a)
    if not a then return false end
    -- this is where a "tolerance" could be implemented:
    return a[1]==b[1] and a[2]==b[2] and a[3]==b[3]
  end
  local function ff(x, y)
    if not matches(self:get(x, y)) then return end
    self:set(x, y, c)
    ff(x+1, y)
    ff(x, y-1)
    ff(x-1, y)
    ff(x, y+1)
  end
  ff(x, y)
end
