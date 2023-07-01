local PeanoLSystem = {
  axiom = "L",
  rules = {
    L = "LFRFL-F-RFLFR+F+LFRFL",
    R = "RFLFR+F+LFRFL-F-RFLFR"
  },
  eval = function(self, n)
    local source, result = self.axiom
    for i = 1, n do
      result = ""
      for j = 1, #source do
        local ch = source:sub(j,j)
        result = result .. (self.rules[ch] and self.rules[ch] or ch)
      end
      source = result
    end
    return result
  end
}

function Bitmap:drawPath(path, x, y, dx, dy)
  self:set(x, y, "@")
  for i = 1, #path do
    local ch = path:sub(i,i)
    if (ch == "F") then
      local reps = dx==0 and 1 or 3 -- aspect correction
      for r = 1, reps do
        x, y = x+dx, y+dy
        self:set(x, y, dx==0 and "|" or "-")
      end
      x, y = x+dx, y+dy
      self:set(x, y, "+")
    elseif (ch =="-") then
      dx, dy = dy, -dx
    elseif (ch == "+") then
      dx, dy = -dy, dx
    end
  end
  self:set(x, y, "X")
end

function Bitmap:render()
  for y = 1, self.height do
    print(table.concat(self.pixels[y]))
  end
end

bitmap = Bitmap(53*2,53)
bitmap:clear(" ")
bitmap:drawPath(PeanoLSystem:eval(3), 0, 0, 0, 1)
bitmap:render()
