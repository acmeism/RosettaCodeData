require "./write_ppm"

img = Pixmap.new 3, 2, Color::WHITE

[[0xFF0000, 0x00FF00, 0x0000FF],
 [0xFFFF00, 0x00FFFF, 0xFF00FF]].each_with_index do |row, y|
  row.each_with_index do |color, x|
    img[x, y] = Color.new color
  end
end

img.write "mini.ppm"

File.read("mini.ppm").unsafe_byte_slice(0).hexdump(STDOUT)
