local cos, sin, floor, pi = math.cos, math.sin, math.floor, math.pi

function Bitmap:render()
  for y = 1, self.height do
    print(table.concat(self.pixels[y]))
  end
end

function Bitmap:drawKochPath(path, x, y, angle, speed, color)
  local rules = {
    ["+"] = function() angle = angle + pi/3 end,
    ["-"] = function() angle = angle - pi/3 end,
    ["F"] = function()
      local nx, ny = x+speed*cos(angle), y+speed*sin(angle)
      self:line(floor(x*2+0.5), floor(y+0.5), floor(nx*2+0.5), floor(ny+0.5), color)
      x, y = nx, ny
    end
  }
  path:gsub("(.)", function(c) rules[c]() end)
end

function LSystem(axiom, rules, reps)
  for i = 1, reps do
    axiom = axiom:gsub("(.)", function(c) return rules[c] or c end)
  end
  return axiom
end
function KochPath(reps) return LSystem("F--F--F--", { F = "F+F--F+F" }, reps) end

demos = {
  { n=0, w= 11, h= 6, x=1, y= 4 },
  { n=1, w= 22, h=14, x=1, y= 9 },
  { n=2, w= 60, h=34, x=1, y=24 },
  { n=3, w=168, h=96, x=1, y=71 }
}
for _,d in ipairs(demos) do
  bitmap = Bitmap(d.w, d.h)
  bitmap:clear(".")
  bitmap:drawKochPath(KochPath(d.n), d.x, d.y, 0, 3, "@")
  bitmap:render()
  print()
end
