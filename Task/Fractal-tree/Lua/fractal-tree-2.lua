function Bitmap:tree(x, y, angle, depth, forkfn, lengfn)
  if depth <= 0 then return end
  local fork, leng = forkfn(), lengfn()
  local x2 = x + depth * leng * math.cos(angle)
  local y2 = y - depth * leng * math.sin(angle)
  self:line(math.floor(x), math.floor(y), math.floor(x2), math.floor(y2))
  self:tree(x2, y2, angle+fork, depth-1, forkfn, lengfn)
  self:tree(x2, y2, angle-fork, depth-1, forkfn, lengfn)
end

bitmap = Bitmap(128*3,128)
bitmap:tree( 64, 120, math.pi/2, 8, function() return 0.3 end, function() return 3 end)
bitmap:tree(192, 120, math.pi/2, 8, function() return 0.6 end, function() return 2.5 end)
bitmap:tree(320, 120, math.pi/2, 8, function() return 0.2+math.random()*0.3 end, function() return 2.0+math.random()*2.0 end)
bitmap:render({[0x000000]='.', [0xFFFFFFFF]='█'})
