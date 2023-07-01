BI = { -- Bounded Integer
  new = function(self, v) return setmetatable({v = self:_limit(v)}, BI_mt) end,
  _limit = function(self,v) return math.max(1, math.min(math.floor(v), 10)) end,
}
BI_mt = {
  __index = BI,
  __call = function(self,v) return self:new(v) end,
  __unm = function(self) return BI(-self.v) end,
  __add = function(self,other) return BI(self.v+other.v) end,
  __sub = function(self,other) return BI(self.v-other.v) end,
  __mul = function(self,other) return BI(self.v*other.v) end,
  __div = function(self,other) return BI(self.v/other.v) end,
  __mod = function(self,other) return BI(self.v%other.v) end,
  __pow = function(self,other) return BI(self.v^other.v) end,
  __eq = function(self,other) return self.v==other.v end,
  __lt = function(self,other) return self.v<other.v end,
  __le = function(self,other) return self.v<=other.v end,
  __tostring = function(self) return tostring(self.v) end
}
setmetatable(BI, BI_mt)
