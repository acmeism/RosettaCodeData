local function simu(ndice1, nsides1, ndice2, nsides2)
  local function roll(ndice, nsides)
    local result = 0;
    for i = 1, ndice do
      result = result + math.random(nsides)
    end
    return result
  end
  local wins, coms = 0, 1000000
  for i = 1, coms do
    local roll1 = roll(ndice1, nsides1)
    local roll2 = roll(ndice2, nsides2)
    if (roll1 > roll2) then
      wins = wins + 1
    end
  end
  print("simulated:  p1 = "..ndice1.."d"..nsides1..", p2 = "..ndice2.."d"..nsides2..",  prob = "..wins.." / "..coms.." = "..(wins/coms))
end

simu(9, 4, 6, 6)
simu(5, 10, 6, 7)
