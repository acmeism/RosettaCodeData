g, angle = love.graphics, 26 * math.pi / 180
wid, hei = g.getWidth(), g.getHeight()
function rotate( x, y, a )
  local s, c = math.sin( a ), math.cos( a )
  local a, b = x * c - y * s, x * s + y * c
  return a, b
end
function branches( a, b, len, ang, dir )
  len = len * .76
  if len < 5 then return end
  g.setColor( len * 16, 255 - 2 * len , 0 )
  if dir > 0 then ang = ang - angle
  else ang = ang + angle
  end
  local vx, vy = rotate( 0, len, ang )
  vx = a + vx; vy = b - vy
  g.line( a, b, vx, vy )
  branches( vx, vy, len, ang, 1 )
  branches( vx, vy, len, ang, 0 )
end
function createTree()
  local lineLen = 127
  local a, b = wid / 2, hei - lineLen
  g.setColor( 160, 40 , 0 )
  g.line( wid / 2, hei, a, b )
  branches( a, b, lineLen, 0, 1 )
  branches( a, b, lineLen, 0, 0 )
end
function love.load()
  canvas = g.newCanvas( wid, hei )
  g.setCanvas( canvas )
  createTree()
  g.setCanvas()
end
function love.draw()
  g.draw( canvas )
end
