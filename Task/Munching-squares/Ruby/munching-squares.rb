load 'raster_graphics.rb'

class Pixmap
  def self.xor_pattern(width, height, rgb1, rgb2)
    # create colour table
    size = 256
    colours = Array.new(size) do |i|
      RGBColour.new(
        (rgb1.red + (rgb2.red - rgb1.red) * i / size),
        (rgb1.green + (rgb2.green - rgb1.green) * i / size),
        (rgb1.blue + (rgb2.blue - rgb1.blue) * i / size),
      )
    end

    # create the image
    pixmap = new(width, height)
    pixmap.each_pixel do |x, y|
      pixmap[x,y] = colours[(x^y)%size]
    end
    pixmap
  end
end

img = Pixmap.xor_pattern(384, 384, RGBColour::RED, RGBColour::YELLOW)
img.save_as_png('xorpattern.png')
