function Bitmap:fiboword(n)
  local function fw(n) return n==1 and "1" or n==2 and "0" or fw(n-1)..fw(n-2) end
  local word, x, y, dx, dy = fw(n), 0, self.height-1, 0, -1
  for i = 1, #word do
    self:set(x, y, "+")
    x, y = x+dx, y+dy
    self:set(x, y, dx==0 and "|" or "-")
    x, y = x+dx, y+dy
    if word:sub(i,i)=="0" then
      dx, dy = i%2==0 and dy or -dy, i%2==0 and -dx or dx
    end
  end
end

function Bitmap:render()
  for y = 1, self.height do
    print(table.concat(self.pixels[y]))
  end
end

bitmap = Bitmap(58,82)
bitmap:clear(" ")
bitmap:fiboword(14)
bitmap:render()
