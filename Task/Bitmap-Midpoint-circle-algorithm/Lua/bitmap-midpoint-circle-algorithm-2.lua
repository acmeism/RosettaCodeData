function Bitmap:axes()
  local hw, hh = math.floor(self.width/2), math.floor(self.height/2)
  for i = 0, self.width-1 do self:set(i,hh,"-") end
  for i = 0, self.height-1 do self:set(hw,i,"|") end
  self:set(hw,hh,"+")
end

function Bitmap:render()
  for y = 1, self.height do
    print(table.concat(self.pixels[y]," "))
  end
end

bitmap = Bitmap(25, 25)
bitmap:clear("·")
bitmap:axes()
bitmap:circle(12, 12, 11, "■")
bitmap:circle(12, 12, 8, "■")
bitmap:circle(12, 12, 5, "■")
bitmap:circle(12, 12, 2, "■")
bitmap:render()
