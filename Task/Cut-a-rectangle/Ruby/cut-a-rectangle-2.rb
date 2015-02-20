class Rectangle
  DIRS = [[1, 0], [-1, 0], [0, -1], [0, 1]]
  def initialize(h, w)
    raise ArgumentError  if (h.odd? and w.odd?) or h<=0 or w<=0
    @h, @w = h, w
    @limit = h * w / 2
  end

  def cut(disp=true)
    @cut = {}
    @select = []
    @result = []
    @grid = make_grid
    walk(0,0)
    display  if disp
    @result
  end

  def make_grid
    Array.new(@h+1) {|i| Array.new(@w+1) {|j| true if i<@h and j<@w }}
  end

  def walk(y, x)
    @grid[y][x] = @grid[@h-y-1][@w-x-1] = false
    @select.push([y,x])
    select = @select.sort
    unless @cut[select]
      @cut[select] = true
      if @select.size == @limit
        @result << select
      else
        search_next.each {|yy,xx| walk(yy,xx)}
      end
    end
    @select.pop
    @grid[y][x] = @grid[@h-y-1][@w-x-1] = true
  end

  def search_next
    nxt = {}
    @select.each do |y,x|
      DIRS.each do |dy, dx|
        nxt[[y+dy, x+dx]] = true  if @grid[y+dy][x+dx]
      end
    end
    nxt.keys
  end

  def display
    @result.each do |select|
      @grid = make_grid
      select.each {|y,x| @grid[y][x] = false}
      puts to_s
    end
  end

  def to_s
    text = Array.new(@h*2+1) {" " * (@w*4+1)}
    for i in 0..@h
      for j in 0..@w
        text[i*2][j*4+1,3] = "---"  if @grid[i][j] != @grid[i-1][j]
        text[i*2+1][j*4]   = "|"    if @grid[i][j] != @grid[i][j-1]
        text[i*2][j*4]     = "+"
      end
    end
    text.join("\n")
  end
end

rec = Rectangle.new(2,2)
puts rec.cut.size

rec = Rectangle.new(3,4)
puts rec.cut.size
