local function T2D(w,h) local t={} for y=1,h do t[y]={} for x=1,w do t[y][x]=0 end end return t end

local Life = {
  new = function(self,w,h)
    return setmetatable({ w=w, h=h, gen=1, curr=T2D(w,h), next=T2D(w,h)}, {__index=self})
  end,
  set = function(self, coords)
    for i = 1, #coords, 2 do
      self.curr[coords[i+1]][coords[i]] = 1
    end
  end,
  evolve = function(self)
    local curr, next = self.curr, self.next
    local ym1, y, yp1 = self.h-1, self.h, 1
    for i = 1, self.h do
      local xm1, x, xp1 = self.w-1, self.w, 1
      for j = 1, self.w do
        local sum = curr[ym1][xm1] + curr[ym1][x] + curr[ym1][xp1] +
                    curr[y][xm1] + curr[y][xp1] +
                    curr[yp1][xm1] + curr[yp1][x] + curr[yp1][xp1]
        next[y][x] = ((sum==2) and curr[y][x]) or ((sum==3) and 1) or 0
        xm1, x, xp1 = x, xp1, xp1+1
      end
      ym1, y, yp1 = y, yp1, yp1+1
    end
    self.curr, self.next, self.gen = self.next, self.curr, self.gen+1
  end,
  render = function(self)
    print("Generation "..self.gen..":")
    for y = 1, self.h do
      for x = 1, self.w do
        io.write(self.curr[y][x]==0 and "□ " or "■ ")
      end
      print()
    end
  end
}
