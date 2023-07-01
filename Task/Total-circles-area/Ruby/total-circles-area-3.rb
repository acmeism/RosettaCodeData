def area_scan(prec, circles)
  sect = ->(y) do
    circles.select{|cx,cy,r| (y - cy).abs < r}.map do |cx,cy,r|
      dr = Math.sqrt(r ** 2 - (y - cy) ** 2)
      [cx - dr, cx + dr]
    end
  end
  xmin, xmax, ymin, ymax = minmax_circle(circles)
  ymin = (ymin / prec).floor
  ymax = (ymax / prec).ceil

  total = 0
  for y in ymin..ymax
    y *= prec
    right = xmin
    for x0, x1 in sect[y].sort
      next  if x1 <= right
      total += x1 - [x0, right].max
      right = x1
    end
  end
  total * prec
end

puts "Scanline Method"
prec = 1e-2
3.times do
  t0 = Time.now
  puts "%8.6f : %12.9f, %p sec" % [prec, area_scan(prec, circles), Time.now-t0]
  prec /= 10
end
