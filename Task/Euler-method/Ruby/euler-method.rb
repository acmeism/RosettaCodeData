def euler(y0,a,b,h, &block)
  t,y = a,y0
  while t < b
    puts "%6.3f %6.3f" % [t,y]
    t += h
    y += h * block.call(t,y)
  end
end

euler(100,0,100,10) {|time, temp| -0.07 * (temp - 20) }
