def d2d (a)  a % 360  end
def g2g (a)  a % 400  end
def m2m (a)  a % 6400 end
def r2r (a)  a.to_f % (2*Math::PI) end

def d2g (a)  d2d(a)/360 * 400  end
def d2m (a)  d2d(a)/360 * 6400 end
def d2r (a)  d2d(a)/360 * 2*Math::PI end

def g2d (a)  g2g(a)/400 * 360  end
def g2m (a)  g2g(a)/400 * 6400 end
def g2r (a)  g2g(a)/400 * 2*Math::PI end

def m2d (a)  m2m(a)/6400 * 360  end
def m2g (a)  m2m(a)/6400 * 400  end
def m2r (a)  m2m(a)/6400 * 2*Math::PI end

def r2d (a)  r2r(a)/(2*Math::PI) * 360  end
def r2g (a)  r2r(a)/(2*Math::PI) * 400  end
def r2m (a)  r2r(a)/(2*Math::PI) * 6400 end

angles = [-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000]

puts "%-12s %-8s %12s %12s %12s %12s" % {"Angle", "Unit", "Degrees", "Gradians", "Mils", "Radians"}
puts "-"*(12+8+12+12+12+12+5)
angles.each do |a|
  puts "%-12g %-8s %12g %12g %12g %12g" % {a, "degrees",  d2d(a), d2g(a), d2m(a), d2r(a) }
  puts "%-12g %-8s %12g %12g %12g %12g" % {a, "gradians", g2d(a), g2g(a), g2m(a), g2r(a) }
  puts "%-12g %-8s %12g %12g %12g %12g" % {a, "mils",     m2d(a), m2g(a), m2m(a), m2r(a) }
  puts "%-12g %-8s %12g %12g %12g %12g" % {a, "radians",  r2d(a), r2g(a), r2m(a), r2r(a) }
  puts
end
