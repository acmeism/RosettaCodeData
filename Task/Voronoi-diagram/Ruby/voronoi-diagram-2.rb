# frozen_string_literal: true

Tile = Struct.new(:x, :y, :color) do
  def sq_dist(a, b)
    (x - a)**2 + (y - b)**2
  end
end

attr_reader :tiles

def settings
  size 500, 500
end

def setup
  sketch_title 'Voronoi Diagram'
  load_pixels
  color_mode(HSB, 1.0)
  @tiles = generate_tiles(30)
  draw_voronoi
  update_pixels
  draw_voronoi_centers
end

def generate_tiles(num)
  (0..num).map { Tile.new(rand(width), rand(height), color(rand, 1.0, 1.0)) }
end

def draw_voronoi
  grid(width, height) do |x, y|
    closest = tiles.min_by { |tile| tile.sq_dist(x, y) }
    pixels[x + y * width] = closest.color
  end
end

def draw_voronoi_centers
  tiles.each do |center|
    no_stroke
    fill 0
    ellipse(center.x, center.y, 4, 4)
  end
end
