require 'prime'

def cell(n, x, y, start=1)
  y, x = y - n/2, x - (n - 1)/2
  l = 2 * [x.abs, y.abs].max
  d = y >= x ? l*3 + x + y : l - x - y
  (l - 1)**2 + d + start - 1
end

def show_spiral(n, symbol=nil, start=1)
  puts "\nN : #{n}"
  format = "%#{(start + n*n - 1).to_s.size}s "
  n.times do |y|
    n.times do |x|
      i = cell(n,x,y,start)
      if symbol
        print i.prime? ? symbol[0] : symbol[1]
      else
        print format % (i.prime? ? i : '')
      end
    end
    puts
  end
end

show_spiral(9)
show_spiral(25)
show_spiral(25, "# ")
