-- 2048 for Lua 5.1-5.4, 12/3/2020 db
local unpack = unpack or table.unpack -- for 5.3 +/- compatibility
game = {
  cell = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
  best = 0,
  draw = function(self)
    local t = self.cell
    print("+----+----+----+----+")
    for r=0,12,4 do
      print(string.format("|%4d|%4d|%4d|%4d|\n+----+----+----+----+",t[r+1],t[r+2],t[r+3],t[r+4]))
    end
  end,
  incr = function(self)
    local t,open = self.cell,{}
    for i=1,16 do if t[i]==0 then open[#open+1]=i end end
    t[open[math.random(#open)]] = math.random()<0.1 and 4 or 2
  end,
  pack = function(self,ofr,oto,ost,ifr,ito,ist)
    local t = self.cell
    for outer=ofr,oto,ost do
      local skip = 0
      for inner=ifr,ito,ist do
        local i = outer+inner
        if t[i]==0 then skip=skip+1 else if skip>0 then t[i-skip*ist],t[i],self.diff = t[i],0,true end end
      end
    end
  end,
  comb = function(self,ofr,oto,ost,ifr,ito,ist)
    local t = self.cell
    for outer=ofr,oto,ost do
      for inner=ifr,ito-ist,ist do
        local i,j = outer+inner,outer+inner+ist
        if t[i]>0 and t[i]==t[j] then t[i],t[j],self.diff,self.best = t[i]*2,0,true,math.max(self.best,t[i]*2) end
      end
    end
  end,
  move = function(self,dir)
    local loopdata = {{0,12,4,1,4,1},{0,12,4,4,1,-1},{1,4,1,0,12,4},{1,4,1,12,0,-4}}
    local ofr,oto,ost,ifr,ito,ist = unpack(loopdata[dir])
    self:pack(ofr,oto,ost,ifr,ito,ist)
    self:comb(ofr,oto,ost,ifr,ito,ist)
    self:pack(ofr,oto,ost,ifr,ito,ist)
  end,
  full = function(self)
    local t = self.cell
    for r=0,12,4 do
      for c=1,4 do
        local i,v = r+c,t[r+c]
        if (v==0) or (c>1 and t[i-1]==v) or (c<4 and t[i+1]==v) or (r>0 and t[i-4]==v) or (r<12 and t[i+4]==v) then
          return false
        end
      end
    end
    return true
  end,
  play = function(self)
    math.randomseed(os.time())
    self:incr()
    self:incr()
    while true do
      self:draw()
      if self.best==2048 then print("WIN!") break end
      if self:full() then print("LOSE!") break end
      io.write("Your move (wasd + enter, or q + enter to quit):  ")
      local char = io.read()
      self.diff = false
      if (char=="a") then self:move(1)
      elseif (char=="d") then self:move(2)
      elseif (char=="w") then self:move(3)
      elseif (char=="s") then self:move(4)
      elseif (char=="q") then break end
      if self.diff then self:incr() end
    end
  end
}
game:play()
