require "complex"
require "crimage"

R = 70

img = CrImage.rgba(R*2, R*2, CrImage::Color::WHITE)

(-R...R).each do |y|
  (-R...R).each do |x|
    c = Complex.new(x, y)
    length, angle = c.polar
    next unless length <= R
    img[x+R, y+R] = CrImage::Color::HSV.new(angle * (180.0 / Math::PI), length/R, 1.0)
  end
end

CrImage.write("color_wheel_crystal.png", img)
