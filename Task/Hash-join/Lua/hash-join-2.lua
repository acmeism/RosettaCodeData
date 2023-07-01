local hashlist = {
  new = function(self,key)
    return setmetatable({key=key, hash={}, list={}}, {__index=self})
  end,
  insert = function(self,row)
    self.list[#self.list+1] = row
    if not self.hash[row[self.key]] then self.hash[row[self.key]]={} end
    table.insert(self.hash[row[self.key]], row)
    return self
  end,
  join = function(self,tabb)
    local result = {}
    for _,rowb in pairs(tabb.list) do
      if (self.hash[rowb[tabb.key]]) then
        for _,rowa in pairs(self.hash[rowb[tabb.key]]) do
          result[#result+1] = { A=rowa, B=rowb }
        end
      end
    end
    return result
  end
}

local function recA(age, name) return { Age=age, Name=name } end
tabA = hashlist:new("Name")
  :insert(recA(27,"Jonah"))
  :insert(recA(18,"Alan"))
  :insert(recA(28,"Glory"))
  :insert(recA(18,"Popeye"))
  :insert(recA(28,"Alan"))

local function recB(character, nemesis) return { Character=character, Nemesis=nemesis } end
local tabB = hashlist:new("Character")
  :insert(recB("Jonah","Whales"))
  :insert(recB("Jonah","Spiders"))
  :insert(recB("Alan","Ghosts"))
  :insert(recB("Alan","Zombies"))
  :insert(recB("Glory","Buffy"))

for _,row in pairs(tabA:join(tabB)) do
  print(row.A.Age, row.A.Name, row.B.Character, row.B.Nemesis)
end
print("or vice versa:")
for _,row in pairs(tabB:join(tabA)) do
  print(row.B.Age, row.B.Name, row.A.Character, row.A.Nemesis)
end
