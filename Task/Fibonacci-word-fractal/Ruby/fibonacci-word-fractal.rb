def fibonacci_word(n)
  words = ["1", "0"]
  (n-1).times{ words << words[-1] + words[-2] }
  words[n]
end

def print_fractal(word)
  area = Hash.new(" ")
  x = y = 0
  dx, dy = 0, -1
  area[[x,y]] = "S"
  word.each_char.with_index(1) do |c,n|
    area[[x+dx, y+dy]] = dx.zero? ? "|" : "-"
    x, y = x+2*dx, y+2*dy
    area[[x, y]] = "+"
    dx,dy = n.even? ? [dy,-dx] : [-dy,dx]  if c=="0"
  end

  (xmin, xmax), (ymin, ymax) = area.keys.transpose.map(&:minmax)
  for y in ymin..ymax
    puts (xmin..xmax).map{|x| area[[x,y]]}.join
  end
end

word = fibonacci_word(16)
print_fractal(word)
