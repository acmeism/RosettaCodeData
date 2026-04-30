require "./pixmap"

img = Pixmap.new(10, 5)
(0...10).each do |x|
  img[x, x // 2] = Color::WHITE
  img[9-x, x // 2] = Color::RED
end

img.write(STDOUT)
