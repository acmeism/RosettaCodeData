-- needed for actual task
cube.scale = function(self, sx, sy, sz)
  for i,v in ipairs(self.verts) do
    v[1], v[2], v[3] = v[1]*sx, v[2]*sy, v[3]*sz
  end
end
-- only needed for output
-- (to size it for screen, given a limited camera)
cube.translate = function(self, tx, ty, tz)
  for i,v in ipairs(self.verts) do
    v[1], v[2], v[3] = v[1]+tx, v[2]+ty, v[3]+tz
  end
end
