local RNG = {
  new = function(class, a, c, m, rand)
    local self = setmetatable({}, class)
    local state = 0
    self.rnd = function()
      state = (a * state + c) % m
      return rand and rand(state) or state
    end
    self.seed = function(new_seed)
      state = new_seed % m
    end
    return self
  end
}

bsd = RNG:new(1103515245, 12345, 1<<31)
ms = RNG:new(214013, 2531011, 1<<31, function(s) return s>>16 end)

print"BSD:"
for _ = 1,10 do
  print(("\t%10d"):format(bsd.rnd()))
end
print"Microsoft:"
for _ = 1,10 do
  print(("\t%10d"):format(ms.rnd()))
end
