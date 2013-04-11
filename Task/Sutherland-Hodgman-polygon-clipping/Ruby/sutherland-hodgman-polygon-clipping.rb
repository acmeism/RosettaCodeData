Point = Struct.new(:x,:y)

def sutherland_hodgman subjectPolygon, clipPolygon
  # These inner functions reduce the argument passing to
  # _inside_ and _intersection_.
  cp1, cp2, e, s = nil
  inside = proc do |p|
    next (cp2.x-cp1.x)*(p.y-cp1.y) > (cp2.y-cp1.y)*(p.x-cp1.x)
  end
  intersection = proc do
    dcx, dcy = cp1.x-cp2.x, cp1.y-cp2.y
    dpx, dpy = s.x-e.x, s.y-e.y
    n1 = cp1.x*cp2.y - cp1.y*cp2.x
    n2 = s.x*e.y - s.y*e.x
    n3 = 1.0 / (dcx*dpy - dcy*dpx)
    next Point.new((n1*dpx - n2*dcx) * n3, (n1*dpy - n2*dcy) * n3)
  end

  outputList = subjectPolygon
  cp1 = clipPolygon.last
  clipPolygon.each do |point|
    cp2 = point
    inputList = outputList
    outputList = []
    s = inputList.last
    inputList.each do |point|
      e = point
      if inside[e]
	outputList << intersection[] if !inside[s]
	outputList << e
      elsif inside[s]
	outputList << intersection[]
      end
      s = e
    end
    cp1 = cp2
  end
  outputList
end

$subjectPolygon = [[50, 150], [200, 50], [350, 150], [350, 300],
                   [250, 300], [200, 250], [150, 350], [100, 250],
                   [100, 200]].collect{|pnt| Point.new(*pnt)}

$clipPolygon = [[100, 100], [300, 100], [300, 300],
                [100, 300]].collect{|pnt| Point.new(*pnt)}

puts sutherland_hodgman($subjectPolygon, $clipPolygon).collect{|pnt|
  "(#{pnt.x},#{pnt.y})"}.join(", ")
