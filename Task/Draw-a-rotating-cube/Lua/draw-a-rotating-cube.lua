local abs,atan,cos,floor,pi,sin,sqrt = math.abs,math.atan,math.cos,math.floor,math.pi,math.sin,math.sqrt
local bitmap = {
  init = function(self, w, h, value)
    self.w, self.h, self.pixels = w, h, {}
    for y=1,h do self.pixels[y]={} end
    self:clear(value)
  end,
  clear = function(self, value)
    for y=1,self.h do
      for x=1,self.w do
        self.pixels[y][x] = value or "  "
      end
    end
  end,
  set = function(self, x, y, value)
    x,y = floor(x),floor(y)
    if x>0 and y>0 and x<=self.w and y<=self.h then
      self.pixels[y][x] = value or "#"
    end
  end,
  line = function(self, x1, y1, x2, y2, c)
    x1,y1,x2,y2 = floor(x1),floor(y1),floor(x2),floor(y2)
    local dx, sx = abs(x2-x1), x1<x2 and 1 or -1
    local dy, sy = abs(y2-y1), y1<y2 and 1 or -1
    local err = floor((dx>dy and dx or -dy)/2)
    while(true) do
      self:set(x1, y1, c)
      if (x1==x2 and y1==y2) then break end
      if (err > -dx) then
        err, x1 = err-dy, x1+sx
        if (x1==x2 and y1==y2) then
          self:set(x1, y1, c)
          break
        end
      end
      if (err < dy) then
        err, y1 = err+dx, y1+sy
      end
    end
  end,
  render = function(self)
    for y=1,self.h do
      print(table.concat(self.pixels[y]))
    end
  end,
}
screen = {
  clear = function()
    os.execute("cls") -- or? os.execute("clear"), or? io.write("\027[2J\027[H"), or etc?
  end,
}
local camera = { fl = 2.5 }
local L = 0.5
local cube = {
  verts = { {L,L,L}, {L,-L,L}, {-L,-L,L}, {-L,L,L}, {L,L,-L}, {L,-L,-L}, {-L,-L,-L}, {-L,L,-L} },
  edges = { {1,2}, {2,3}, {3,4}, {4,1}, {5,6}, {6,7}, {7,8}, {8,5}, {1,5}, {2,6}, {3,7}, {4,8} },
  rotate = function(self, rx, ry)
    local cx,sx = cos(rx),sin(rx)
    local cy,sy = cos(ry),sin(ry)
    for i,v in ipairs(self.verts) do
      local x,y,z = v[1],v[2],v[3]
      v[1], v[2], v[3] = x*cx-z*sx, y*cy-x*sx*sy-z*cx*sy, x*sx*cy+y*sy+z*cx*cy
    end
  end,
}
local renderer = {
  render = function(self, shape, camera, bitmap)
    local fl = camera.fl
    local ox, oy = bitmap.w/2, bitmap.h/2
    local mx, my = bitmap.w/2, bitmap.h/2
    local rpverts = {}
    for i,v in ipairs(shape.verts) do
      local x,y,z = v[1],v[2],v[3]
      local px = ox + mx * (fl*x)/(fl-z)
      local py = oy + my * (fl*y)/(fl-z)
      rpverts[i] = { px,py }
    end
    for i,e in ipairs(shape.edges) do
      local v1, v2 = rpverts[e[1]], rpverts[e[2]]
      bitmap:line( v1[1], v1[2], v2[1], v2[2], "██" )
    end
  end
}
--
bitmap:init(40,40)
cube:rotate(pi/4, atan(sqrt(2)))
for i=1,60 do
  cube:rotate(pi/60,0)
  bitmap:clear("··")
  renderer:render(cube, camera, bitmap)
  screen:clear()
  bitmap:render()
end
