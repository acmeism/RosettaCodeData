|p|
p := Point x:10 y:20.
ObjectMemory addressOf:p.
ObjectMemory collectGarbage.
ObjectMemory addressOf:p
