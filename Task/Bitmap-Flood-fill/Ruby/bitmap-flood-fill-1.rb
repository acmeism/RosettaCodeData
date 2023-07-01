# frozen_string_literal: true

require_relative 'raster_graphics'

class RGBColour
  def ==(other)
    values == other.values
  end
end

class Pixmap
  def flood_fill(pixel, new_colour)
    current_colour = self[pixel.x, pixel.y]
    queue = Queue.new
    queue.enq(pixel)
    until queue.empty?
      p = queue.pop
      next unless self[p.x, p.y] == current_colour

      west = find_border(p, current_colour, :west)
      east = find_border(p, current_colour, :east)
      draw_line(west, east, new_colour)
      q = west
      while q.x <= east.x
        %i[north south].each do |direction|
          n = neighbour(q, direction)
          queue.enq(n) if self[n.x, n.y] == current_colour
        end
        q = neighbour(q, :east)
      end
    end
  end

  def neighbour(pixel, direction)
    case direction
    when :north then Pixel[pixel.x, pixel.y - 1]
    when :south then Pixel[pixel.x, pixel.y + 1]
    when :east  then Pixel[pixel.x + 1, pixel.y]
    when :west  then Pixel[pixel.x - 1, pixel.y]
    end
  end

  def find_border(pixel, colour, direction)
    nextp = neighbour(pixel, direction)
    while self[nextp.x, nextp.y] == colour
      pixel = nextp
      nextp = neighbour(pixel, direction)
    end
    pixel
  end
end

bitmap = Pixmap.new(300, 300)
bitmap.draw_circle(Pixel[149, 149], 120, RGBColour::BLACK)
bitmap.draw_circle(Pixel[200, 100], 40, RGBColour::BLACK)
bitmap.flood_fill(Pixel[140, 160], RGBColour::BLUE)
bitmap.save_as_png('flood_fill.png')
