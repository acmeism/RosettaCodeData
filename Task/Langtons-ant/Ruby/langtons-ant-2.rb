class Ant
  MOVE = [[1,0], [0,1], [-1,0], [0,-1]]   # [0]:east, [1]:south, [2]:west, [3]:north

  def initialize(size_x, size_y, pos_x=size_x/2, pos_y=size_y/2)
    @plane = Array.new(size_y) {Array.new(size_x, true)}  # true -> white, false -> black
    @sx, @sy = size_x, size_y
    @px, @py = pos_x, pos_y       # start position
    @direction = 0                # south
    @moves = 0
    move  while (0 <= @px and @px < @sx) and (0 <= @py and @py < @sy)
  end

  def move
    @moves += 1
    @direction = (@plane[@py][@px] ? @direction+1 : @direction-1) % 4
    @plane[@py][@px] = !@plane[@py][@px]
    @px += MOVE[@direction][0]
    @py += MOVE[@direction][1]
  end

  def to_s
    ["out of bounds after #{@moves} moves: (#@px, #@py)"] +
      (0...@sy).map {|y| (0...@sx).map {|x| @plane[y][x] ? "." : "#"}.join}
  end
end

puts Ant.new(100, 100).to_s
