require "complex"

def deg_to_rad (d)
  d * Math::PI / 180
end

def rad_to_deg (r)
  r * 180 / Math::PI
end

def mean_angle (angles)
  rad_to_deg(angles.sum {|deg| deg_to_rad(deg).cis }.phase)
end

[[350, 10], [90, 180, 270, 360], [10, 20, 30]].each do |angles|
  puts "The mean angle of %s is: %.2f°." % [angles, mean_angle(angles)]
end
