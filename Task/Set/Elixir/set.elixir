iex(1)> s = MapSet.new
#MapSet<[]>
iex(2)> sa = MapSet.put(s, :a)
#MapSet<[:a]>
iex(3)> sab = MapSet.put(sa, :b)
#MapSet<[:a, :b]>
iex(4)> sbc = Enum.into([:b, :c], MapSet.new)
#MapSet<[:b, :c]>
iex(5)> MapSet.member?(sab, :a)
true
iex(6)> MapSet.member?(sab, :c)
false
iex(7)> :a in sab
true
iex(8)> MapSet.union(sab, sbc)
#MapSet<[:a, :b, :c]>
iex(9)> MapSet.intersection(sab, sbc)
#MapSet<[:b]>
iex(10)> MapSet.difference(sab, sbc)
#MapSet<[:a]>
iex(11)> MapSet.disjoint?(sab, sbc)
false
iex(12)> MapSet.subset?(sa, sab)
true
iex(13)> MapSet.subset?(sab, sa)
false
iex(14)> sa == sab
false
