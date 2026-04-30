require "./pixmap"

class Pixmap
  def write_ppm (io)
    io.print "P6\n# Visit Rosetta code!\n#{width} #{height}\n255\n"
    @data.each do |c|
      io.write_byte c.r
      io.write_byte c.g
      io.write_byte c.b
    end
  end
  register_writer ".ppm", write_ppm
end
