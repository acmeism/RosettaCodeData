let haystack = ["Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"]

for needle in ["Bush", "Washington"]:
  let f = haystack.find(needle)
  if f >= 0:
    echo f, " ", needle
  else:
    raise newException(ValueError, needle & " not in haystack")
