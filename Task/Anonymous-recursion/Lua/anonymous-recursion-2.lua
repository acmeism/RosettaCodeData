return setmetatable({1,1},{__index = function(self, n)
  self[n] = self[n-1] + self[n-2]
  return self[n]
end})
