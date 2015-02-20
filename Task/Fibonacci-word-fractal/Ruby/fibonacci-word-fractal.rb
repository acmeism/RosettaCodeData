def fibonacci_word(n)
  words = ["1", "0"]
  (words.size..n).each do |i|
    words << words[i-1] + words[i-2]
  end
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

  xmin, xmax = area.each_key.map(&:first).minmax
  ymin, ymax = area.each_key.map(&:last).minmax
  for y in ymin..ymax
    for x in xmin..xmax
      print area[[x,y]]
    end
    puts
  end
end

word = fibonacci_word(11)
print_fractal(word)
