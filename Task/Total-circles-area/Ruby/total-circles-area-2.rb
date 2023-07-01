def grid_sample(circles, box_side=500)
  # compute the bounding box of the circles
  xmin, xmax, ymin, ymax = minmax_circle(circles)

  dx = (xmax - xmin) / box_side
  dy = (ymax - ymin) / box_side

  circle2 = circles.map{|cx,cy,r| [cx,cy,r*r]}
  include = ->(x,y){circle2.any?{|cx, cy, r2| (x-cx)**2 + (y-cy)**2 < r2}}
  count = 0

  box_side.times do |r|
    y = ymin + r * dy
    box_side.times do |c|
      x = xmin + c * dx
      count += 1  if include[x,y]
    end
  end
  #puts box_side => "Approximated area:#{count * dx * dy}"
  count * dx * dy
end

puts "Grid Sample"
n = 500
2.times do
  t0 = Time.now
  puts "Approximated area:#{grid_sample(circles, n)} (#{n} grid)"
  n *= 2
  puts "#{Time.now - t0} sec"
end
