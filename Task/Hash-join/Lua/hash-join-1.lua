local function recA(age, name) return { Age=age, Name=name } end
local tabA = { recA(27,"Jonah"), recA(18,"Alan"), recA(28,"Glory"), recA(18,"Popeye"), recA(28,"Alan") }

local function recB(character, nemesis) return { Character=character, Nemesis=nemesis } end
local tabB = { recB("Jonah","Whales"), recB("Jonah","Spiders"), recB("Alan","Ghosts"), recB("Alan","Zombies"), recB("Glory","Buffy") }

local function hashjoin(taba, cola, tabb, colb)
  local hash, join = {}, {}
  for _,rowa in pairs(taba) do
    if (not hash[rowa[cola]]) then hash[rowa[cola]] = {} end
    table.insert(hash[rowa[cola]], rowa)
  end
  for _,rowb in pairs(tabb) do
    for _,rowa in pairs(hash[rowb[colb]]) do
      join[#join+1] = { A=rowa, B=rowb }
    end
  end
  return join
end

for _,row in pairs(hashjoin(tabA, "Name", tabB, "Character")) do
  print(row.A.Age, row.A.Name, row.B.Character, row.B.Nemesis)
end
