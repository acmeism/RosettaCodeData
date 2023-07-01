for _,v in ipairs({ 0.9054054, 0.518518, 0.75, math.pi }) do
  local n, d, dmax, eps = 1, 1, 1e7, 1e-15
  while math.abs(n/d-v)>eps and d<dmax do d=d+1 n=math.floor(v*d) end
  print(string.format("%15.13f --> %d / %d", v, n, d))
end
