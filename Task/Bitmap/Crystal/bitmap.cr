class RGBColor
  getter red, green, blue

  def initialize(@red = 0_u8, @green = 0_u8, @blue = 0_u8)
  end

  RED   = new(red: 255_u8)
  GREEN = new(green: 255_u8)
  BLUE  = new(blue: 255_u8)
  BLACK = new
  WHITE = new(255_u8, 255_u8, 255_u8)
end

class Pixmap
  getter width, height
  @data : Array(Array(RGBColor))

  def initialize(@width : Int32, @height : Int32)
    @data = Array.new(@width) { Array.new(@height, RGBColor::WHITE) }
  end

  def fill(color)
    @data.each &.fill(color)
  end

  def [](x, y)
    @data[x][y]
  end

  def []=(x, y, color)
    @data[x][y] = color
  end
end

bmap = Pixmap.new(5, 5)
pp bmap
