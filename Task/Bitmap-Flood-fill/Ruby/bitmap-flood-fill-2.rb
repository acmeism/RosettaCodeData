# holder for pixel coords
Pixel = Struct.new(:x, :y)

attr_reader :img, :fill_color, :queue, :value

def setup
  sketch_title 'Flood Fill'
  @img = load_image(data_path('image.png'))
  @fill_color = color(250, 0, 0)
end

def draw
  image(img, 0, 0, width, height)
  no_loop
end

def mouse_clicked
  img.load_pixels
  flood(mouse_x, mouse_y)
  img.update_pixels
  redraw
end

def flood(x, y)
  @queue = Queue.new
  queue.enq(Pixel.new(x, y))
  until queue.empty?
    pix = queue.pop
    next unless check(pix, color(255))

    queue.enq(Pixel.new(pix.x, pix.y - 1))
    queue.enq(Pixel.new(pix.x, pix.y + 1))
    queue.enq(Pixel.new(pix.x - 1, pix.y))
    queue.enq(Pixel.new(pix.x + 1, pix.y))
  end
end

def check(pix, target_color)
  unless (1...width).include?(pix.x) && (1...height).include?(pix.y)
    return false
  end

  value = img.pixels[pix.x + (pix.y * img.width)]
  return false if target_color != value

  img.pixels[pix.x + (pix.y * img.width)] = fill_color
  true
end

def settings
  size(256, 256)
end
