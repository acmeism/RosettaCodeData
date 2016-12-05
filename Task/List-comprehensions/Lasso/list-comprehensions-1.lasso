#!/usr/bin/lasso9

local(n = 20)
local(triples =
  with x in generateSeries(1, #n),
       y in generateSeries(#x, #n),
       z in generateSeries(#y, #n)
    where #x*#x + #y*#y == #z*#z
  select (:#x, #y, #z)
)
#triples->join('\n')
