local sandpile = {
  init = function(self, dim, val)
    self.cell, self.dim = {}, dim
    for r = 1, dim do
      self.cell[r] = {}
      for c = 1, dim do
        self.cell[r][c] = 0
      end
    end
    self.cell[math.floor(dim/2)+1][math.floor(dim/2)+1] = val
  end,
  iter = function(self)
    local dim, cel, more = self.dim, self.cell
    repeat
      more = false
      for r = 1, dim do
        for c = 1, dim do
          if cel[r][c] >= 4 then
            cel[r][c] = cel[r][c] - 4
            if c > 1 then cel[r][c-1], more = cel[r][c-1]+1, more or cel[r][c-1]>=3 end
            if c < dim then cel[r][c+1], more = cel[r][c+1]+1, more or cel[r][c+1]>=3 end
            if r > 1 then cel[r-1][c], more = cel[r-1][c]+1, more or cel[r-1][c]>=3 end
            if r < dim then cel[r+1][c], more = cel[r+1][c]+1, more or cel[r+1][c]>=3 end
          end
          more = more or cel[r][c] >= 4
        end
      end
    until not more
  end,
  draw = function(self)
    for r = 1, self.dim do
      print(table.concat(self.cell[r]," "))
    end
  end,
}
sandpile:init(15, 256)
sandpile:iter()
sandpile:draw()
