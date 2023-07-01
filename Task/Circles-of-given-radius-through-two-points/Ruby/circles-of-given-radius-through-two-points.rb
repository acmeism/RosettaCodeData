Pt     = Struct.new(:x, :y)
Circle = Struct.new(:x, :y, :r)

def circles_from(pt1, pt2, r)
  raise ArgumentError, "Infinite number of circles, points coincide." if pt1 == pt2 && r > 0
  # handle single point and r == 0
  return [Circle.new(pt1.x, pt1.y, r)] if pt1 == pt2 && r == 0
  dx, dy = pt2.x - pt1.x, pt2.y - pt1.y
  # distance between points
  q = Math.hypot(dx, dy)
  # Also catches pt1 != pt2 && r == 0
  raise ArgumentError, "Distance of points > diameter." if q > 2.0*r
  # halfway point
  x3, y3 = (pt1.x + pt2.x)/2.0, (pt1.y + pt2.y)/2.0
  d = (r**2 - (q/2)**2)**0.5
  [Circle.new(x3 - d*dy/q, y3 + d*dx/q, r),
   Circle.new(x3 + d*dy/q, y3 - d*dx/q, r)].uniq
end

# Demo:
ar = [[Pt.new(0.1234, 0.9876), Pt.new(0.8765, 0.2345), 2.0],
      [Pt.new(0.0000, 2.0000), Pt.new(0.0000, 0.0000), 1.0],
      [Pt.new(0.1234, 0.9876), Pt.new(0.1234, 0.9876), 2.0],
      [Pt.new(0.1234, 0.9876), Pt.new(0.8765, 0.2345), 0.5],
      [Pt.new(0.1234, 0.9876), Pt.new(0.1234, 0.9876), 0.0]]

ar.each do |p1, p2, r|
  print "Given points:\n  #{p1.values},\n  #{p2.values}\n  and radius #{r}\n"
  begin
    circles = circles_from(p1, p2, r)
    puts "You can construct the following circles:"
    circles.each{|c| puts "  #{c}"}
  rescue ArgumentError => e
    puts e
  end
  puts
end
