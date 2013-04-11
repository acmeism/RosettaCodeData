class RGBColour
  def self.mandel_colour(i)
    self.new( 16*(i % 15), 32*(i % 7), 8*(i % 31) )
  end
end

class Pixmap
  def self.mandelbrot(width, height)
    mandel = Pixmap.new(width,height)
    pb = ProgressBar.new(width) if $DEBUG
    width.times do |x|
      height.times do |y|
        x_ish = Float(x - width*11/15) / (width/3)
        y_ish = Float(y - height/2) / (height*3/10)
        mandel[x,y] = RGBColour.mandel_colour(mandel_iters(x_ish, y_ish))
      end
      pb.update(x) if $DEBUG
    end
    pb.close if $DEBUG
    mandel
  end

  def self.mandel_iters(cx,cy)
    x = y = 0.0
    count = 0
    while Math.hypot(x,y) < 2 and count < 255
      x, y = (x**2 - y**2 + cx), (2*x*y + cy)
      count += 1
    end
    count
  end
end

Pixmap.mandelbrot(300,300).save('mandel.ppm')
