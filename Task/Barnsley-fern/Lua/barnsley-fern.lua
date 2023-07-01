g = love.graphics
wid, hei = g.getWidth(), g.getHeight()

function choose( i, j )
  local r = math.random()
  if r < .01 then return 0, .16 * j
    elseif r < .07 then return .2 * i - .26 * j, .23 * i + .22 * j + 1.6
    elseif r < .14 then return -.15 * i + .28 * j, .26 * i + .24 * j + .44
    else return .85 * i + .04 * j, -.04 * i + .85 * j + 1.6
  end
end
function createFern( iterations )
  local hw, x, y, scale = wid / 2, 0, 0, 45
  local pts = {}
  for k = 1, iterations do
    pts[1] = { hw + x * scale, hei - 15 - y * scale,
               20 + math.random( 80 ),
               128 + math.random( 128 ),
               20 + math.random( 80 ), 150 }
    g.points( pts )
    x, y = choose( x, y )
  end
end
function love.load()
  math.randomseed( os.time() )
  canvas = g.newCanvas( wid, hei )
  g.setCanvas( canvas )
  createFern( 15e4 )
  g.setCanvas()
end
function love.draw()
  g.draw( canvas )
end
