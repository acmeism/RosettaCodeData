record Color, r : UInt8, g : UInt8, b : UInt8 do
  def self.new (r : Int32, g : Int32, b : Int32)
    self.new r.to_u8, g.to_u8, b.to_u8
  end

  def self.new (hex : Int32)
    self.new (hex >> 16 & 0xFF).to_u8, (hex >> 8 & 0xFF).to_u8, (hex & 0xFF).to_u8
  end

  def to_i
    (r.to_i << 16) + (g.to_i << 8) + b.to_i
  end

  def == (other : Color)
    self.to_i == other.to_i
  end

  WHITE   = new 0xFFFFFF
  BLACK   = new 0x000000
  RED     = new 0xFF0000
  GREEN   = new 0x00FF00
  BLUE    = new 0x0000FF
end

class Pixmap
  getter width, height
  @data : Array(Color)

  def initialize (@width : Int32, @height : Int32, bg_color = Color::BLACK)
    @data = Array.new(@width * @height, bg_color)
  end

  def initialize (@width : Int32, @height : Int32, @data : Array(Color), copy = false)
    raise "Wrong bounds" unless @width * @height == @data.size
    @data = @data.dup if copy
  end

  def initialize (other : self)
    @width = other.@width
    @height = other.@height
    @data = other.@data.dup
  end

  def fill (color)
    @data.fill color
  end

  def [] (x, y)
    raise "Outside bounds" unless 0 <= x < @width && 0 <= y < @height
    @data[y * @width + x]
  end

  def []= (x, y, color)
    if 0 <= x < @width && 0 <= y < @height
      @data[y * @width + x] = color
    end
    color
  end

  @@loaders = {} of String       => Proc(IO, Pixmap)
  @@writers = {} of String | Nil => Proc(Pixmap, IO, Nil)

  macro register_loader (ext, method)
    @@loaders[{{ext}}] = ->(io : IO) { {{method.id}}(io) }
  end

  macro register_writer (ext, method)
    @@writers[{{ext}}] = ->(img : Pixmap, io : IO) { img.{{method.id}}(io) }
  end

  def self.load (filename)
    ext = File.extname(filename)
    loader = @@loaders[ext]? || raise "No loader for '.#{ext}'"
    File.open(filename) do |f|
      loader.call(f)
    end
  end

  def write (filename_or_io : Path | String | IO)
    if filename_or_io.is_a?(IO)
      writer = @@writers[nil]? || raise "No console writer"
      writer.call(self, filename_or_io)
    else
      ext = File.extname(filename_or_io)
      writer = @@writers[ext]? || raise "No writer for '#{ext}'"
      File.open(filename_or_io, "w") do |f|
        writer.call(self, f)
      end
    end
  end

  def write_poor_text (io)
    (0...@height).each do |y|
      (0...@width).each do |x|
        print case self[x, y]
              when Color::BLACK then '#'
              when Color::WHITE then ' '
              else 'X'
              end
      end
      puts
    end
  end
  register_writer nil, write_poor_text
end
