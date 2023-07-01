local primegen = {
  count_limit = 2,
  value_limit = 3,
  primelist = { 2, 3 },
  nextgenvalue = 5,
  nextgendelta = 2,
  tbd = function(n)
    if n < 2 then return false end
    if n % 2 == 0 then return n==2 end
    if n % 3 == 0 then return n==3 end
    local limit = math.sqrt(n)
    for f = 5, limit, 6 do
      if n % f == 0 or n % (f+2) == 0 then return false end
    end
    return true
  end,
  needmore = function(self)
    return (self.count_limit ~= nil and #self.primelist < self.count_limit)
        or (self.value_limit ~= nil and self.nextgenvalue < self.value_limit)
  end,
  generate = function(self, count_limit, value_limit)
    self.count_limit = count_limit
    self.value_limit = value_limit
    while self:needmore() do
      if (self.tbd(self.nextgenvalue)) then
        self.primelist[#self.primelist+1] = self.nextgenvalue
      end
      self.nextgenvalue = self.nextgenvalue + self.nextgendelta
      self.nextgendelta = 6 - self.nextgendelta
    end
  end,
  filter = function(self, f)
    local list = {}
    for k,v in ipairs(self.primelist) do
      if (f(v)) then list[#list+1] = v end
    end
    return list
  end,
}

primegen:generate(20, nil)
print("First 20 primes:  " .. table.concat(primegen.primelist, ", "))

primegen:generate(nil, 150)
print("Primes between 100 and 150:  " .. table.concat(primegen:filter(function(v) return v>=100 and v<=150 end), ", "))

primegen:generate(nil, 8000)
print("Number of primes between 7700 and 8000:  " .. #primegen:filter(function(v) return v>=7700 and v<=8000 end))

primegen:generate(10000, nil)
print("The 10,000th prime:  " .. primegen.primelist[#primegen.primelist])

primegen:generate(100000, nil)
print("The 100,000th prime:  " .. primegen.primelist[#primegen.primelist])
