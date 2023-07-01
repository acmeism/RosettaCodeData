function Point(x,y) return {x=x, y=y} end

function Polygon(name, points)
  local function contains(self, p)
    local odd, eps = false, 1e-9
    local function rayseg(p, a, b)
      if a.y > b.y then a, b = b, a end
      if p.y == a.y or p.y == b.y then p.y = p.y + eps end
      if p.y < a.y or p.y > b.y or p.x > math.max(a.x, b.x) then return false end
      if p.x < math.min(a.x, b.x) then return true end
      local red = a.x == b.x and math.huge or (b.y-a.y)/(b.x-a.x)
      local blu = a.x == p.x and math.huge or (p.y-a.y)/(p.x-a.x)
      return blu >= red
     end
    for i, a in ipairs(self.points) do
      local b = self.points[i%#self.points+1]
      if rayseg(p, a, b) then odd = not odd end
    end
    return odd
  end
  return {name=name, points=points, contains=contains}
end

polygons = {
  Polygon("square", { Point(0,0), Point(10,0), Point(10,10), Point(0,10) }),
  Polygon("squarehole", { Point(0,0), Point(10,0), Point(10,10), Point(0,10), Point(2.5,2.5), Point(7.5,2.5), Point(7.5,7.5), Point(2.5,7.5) }),
  Polygon("strange", { Point(0,0), Point(2.5,2.5),  Point(0, 10), Point(2.5,7.5), Point(7.5,7.5), Point(10,10), Point(10,0), Point(2.5,2.5) }),
  Polygon("hexagon", { Point(3,0), Point(7,0), Point(10,5), Point(7,10), Point(3,10), Point(0,5) })
}
points = { Point(5,5), Point(5,8), Point(-10,5), Point(0,5), Point(10,5), Point(8,5), Point(10,10) }

for _,poly in ipairs(polygons) do
  print("Does '"..poly.name.."' contain the point..")
  for _,pt in ipairs(points) do
    print(string.format("  (%3.f, %2.f)?  %s", pt.x, pt.y, tostring(poly:contains(pt))))
  end
  print()
end
