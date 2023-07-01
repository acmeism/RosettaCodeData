local CA = {
  state = "..............................#..............................",
  bstr = { [0]="...", "..#", ".#.", ".##", "#..", "#.#", "##.", "###" },
  new = function(self, rule)
    local inst = setmetatable({rule=rule}, self)
    for b = 0,7 do
      inst[inst.bstr[b]] = rule%2==0 and "." or "#"
      rule = math.floor(rule/2)
    end
    return inst
  end,
  evolve = function(self)
    local n, state, newstate = #self.state, self.state, ""
    for i = 1,n do
      local nbhd = state:sub((i+n-2)%n+1,(i+n-2)%n+1) .. state:sub(i,i) .. state:sub(i%n+1,i%n+1)
      newstate = newstate .. self[nbhd]
    end
    self.state = newstate
  end,
}
CA.__index = CA
ca = { CA:new(18), CA:new(30), CA:new(73), CA:new(129) }
for i = 1, 63 do
  print(string.format("%-66s%-66s%-66s%-61s", ca[1].state, ca[2].state, ca[3].state, ca[4].state))
  for j = 1, 4 do ca[j]:evolve() end
end
