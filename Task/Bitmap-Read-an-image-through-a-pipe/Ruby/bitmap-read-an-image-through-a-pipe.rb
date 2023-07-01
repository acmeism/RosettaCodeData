# frozen_string_literal: true

require_relative 'raster_graphics'

class Pixmap
  def self.read_ppm(ios)
    format = ios.gets.chomp
    width, height = ios.gets.chomp.split.map(&:to_i)
    max_colour = ios.gets.chomp

    if !PIXMAP_FORMATS.include?(format) ||
       (width < 1) || (height < 1) ||
       (max_colour != '255')
      ios.close
      raise StandardError, "file '#{filename}' does not start with the expected header"
    end
    ios.binmode if PIXMAP_BINARY_FORMATS.include?(format)

    bitmap = new(width, height)
    height.times do |y|
      width.times do |x|
        # read 3 bytes
        red, green, blue = case format
                           when 'P3' then ios.gets.chomp.split
                           when 'P6' then ios.read(3).unpack('C3')
                           end
        bitmap[x, y] = RGBColour.new(red, green, blue)
      end
    end
    ios.close
    bitmap
  end

  def self.open(filename)
    read_ppm(File.open(filename, 'r'))
  end

  def self.open_from_jpeg(filename)
    read_ppm(IO.popen("convert jpg:#{filename} ppm:-", 'r'))
  end
end

bitmap = Pixmap.open_from_jpeg('foto.jpg')
bitmap.save('foto.ppm')
