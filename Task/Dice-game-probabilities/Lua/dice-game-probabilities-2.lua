local function comp(ndice1, nsides1, ndice2, nsides2)
  local function throws(ndice, nsides)
    local sums = {}
    for i = 1, ndice*nsides do
      sums[i] = 0
    end
    local function throw(ndice, nsides, s)
      if (ndice==0) then
        sums[s] = sums[s] + 1
      else
        for i = 1, nsides do
          throw(ndice-1, nsides, s+i)
        end
      end
      return sums
    end
    return throw(ndice, nsides, 0)
  end
  local p1 = throws(ndice1, nsides1)
  local p2 = throws(ndice2, nsides2)
  local wins, coms = 0, nsides1^ndice1 * nsides2^ndice2
  for k1,v1 in pairs(p1) do
    for k2,v2 in pairs(p2) do
      if (k1 > k2) then
        wins = wins + v1 * v2
      end
    end
  end
  print("computed:  p1 = "..ndice1.."d"..nsides1..", p2 = "..ndice2.."d"..nsides2..", prob = "..wins.." / "..coms.." = "..(wins/coms))
end

comp(9, 4, 6, 6)
comp(5, 10, 6, 7)
