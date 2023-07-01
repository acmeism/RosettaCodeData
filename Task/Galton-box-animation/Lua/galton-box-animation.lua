Bitmap.render = function(self)
  for y = 1, self.height do
    print(table.concat(self.pixels[y], " "))
  end
end

-- globals (tweak here as desired)
math.randomseed(os.time())
local W, H, MIDX = 15, 40, 7
local bitmap = Bitmap(W, H)
local AIR, PIN, BALL, FLOOR = ".", "▲", "☻", "■"
local nballs, balls = 60, {}
local frame, showEveryFrame = 1, false

-- the game board:
bitmap:clear(AIR)
for row = 1, 7 do
  for col = 0, row-1 do
    bitmap:set(MIDX-row+col*2+1, 1+row*2, PIN)
  end
end
for col = 0, W-1 do
  bitmap:set(col, H-1, FLOOR)
end

-- ball class
Ball = {
  new = function(self, x, y, bitmap)
    local instance = setmetatable({ x=x, y=y, bitmap=bitmap, alive=true }, self)
    return instance
  end,
  update = function(self)
    if not self.alive then return end
    self.bitmap:set(self.x, self.y, AIR)
    local newx, newy = self.x, self.y+1
    local below = self.bitmap:get(newx, newy)
    if below==PIN then
      newx = newx + (math.random(2)-1)*2-1
    end
    local there = self.bitmap:get(newx, newy)
    if there==AIR then
      self.x, self.y = newx, newy
    else
      self.alive = false
    end
    self.bitmap:set(self.x, self.y, BALL)
  end,
}
Ball.__index = Ball
setmetatable(Ball, { __call = function (t, ...) return t:new(...) end })

-- simulation:
local function spawn()
  if nballs > 0 then
    balls[#balls+1] = Ball(MIDX, 0, bitmap)
    nballs = nballs - 1
  end
end

spawn()
while #balls > 0 do
  if frame%2==0 then spawn() end
  alive = {}
  for _,ball in ipairs(balls) do
    ball:update()
    if ball.alive then alive[#alive+1]=ball end
  end
  balls = alive
  if frame%50==0 or #alive==0 or showEveryFrame then
    print("FRAME "..frame..":")
    bitmap:render()
  end
  frame = frame + 1
end
