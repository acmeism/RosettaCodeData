require 'set'

def translate2origin(poly)
  # Finds the min x and y coordiate of a Polyomino.
  minx = poly.map(&:first).min
  miny = poly.map(&:last).min
  poly.map{|x,y| [x - minx, y - miny]}.sort
end

def rotate90(x,y) [y, -x] end
def reflect(x,y)  [-x, y] end

# All the plane symmetries of a rectangular region.
def rotations_and_reflections(poly)
  [poly,
   poly = poly.map{|x,y| rotate90(x,y)},
   poly = poly.map{|x,y| rotate90(x,y)},
   poly = poly.map{|x,y| rotate90(x,y)},
   poly = poly.map{|x,y| reflect(x,y)},
   poly = poly.map{|x,y| rotate90(x,y)},
   poly = poly.map{|x,y| rotate90(x,y)},
          poly.map{|x,y| rotate90(x,y)} ]
end

def canonical(poly)
  rotations_and_reflections(poly).map{|pl| translate2origin(pl)}
end

# All four points in Von Neumann neighborhood.
def contiguous(x,y)
  [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
end

# Finds all distinct points that can be added to a Polyomino.
def new_points(poly)
  points = []
  poly.each{|x,y| contiguous(x,y).each{|point| points << point}}
  (points - poly).uniq
end

def new_polys(polys)
  pattern = Set.new
  polys.each_with_object([]) do |poly, polyomino|
    new_points(poly).each do |point|
      next if pattern.include?(pl = translate2origin(poly + [point]))
      polyomino << canonical(pl).each{|p| pattern << p}.min
    end
  end
end

# Generates polyominoes of rank n recursively.
def rank(n)
  case n
  when 0 then [[]]
  when 1 then [[[0,0]]]
  else        new_polys(rank(n-1))
  end
end

# Generates a textual representation of a Polyomino.
def text_representation(poly)
  table = Hash.new(' ')
  poly.each{|x,y| table[[x,y]] = '#'}
  maxx = poly.map(&:first).max
  maxy = poly.map(&:last).max
  (0..maxx).map{|x| (0..maxy).map{|y| table[[x,y]]}.join}
end

p (0..10).map{|n| rank(n).size}
n = ARGV[0] ? ARGV[0].to_i : 5
puts "\nAll free polyominoes of rank %d:" % n
rank(n).sort.each{|poly| puts text_representation(poly),""}
