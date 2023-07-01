class Triangle
  def self.valid?(a,b,c)      # class method
    short, middle, long = [a, b, c].sort
    short + middle > long
  end

  attr_reader :sides, :perimeter, :area

  def initialize(a,b,c)
    @sides = [a, b, c].sort
    @perimeter = a + b + c
    s = @perimeter / 2.0
    @area = Math.sqrt(s * (s - a) * (s - b) * (s - c))
  end

  def heronian?
    area == area.to_i
  end

  def <=>(other)
    [area, perimeter, sides] <=> [other.area, other.perimeter, other.sides]
  end

  def to_s
    "%-11s%6d%8.1f" % [sides.join('x'), perimeter, area]
  end
end

max, area = 200, 210
prim_triangles = []
1.upto(max) do |a|
  a.upto(max) do |b|
    b.upto(max) do |c|
      next if a.gcd(b).gcd(c) > 1
      prim_triangles << Triangle.new(a, b, c) if Triangle.valid?(a, b, c)
    end
  end
end

sorted = prim_triangles.select(&:heronian?).sort

puts "Primitive heronian triangles with sides upto #{max}: #{sorted.size}"
puts "\nsides       perim.   area"
puts sorted.first(10).map(&:to_s)
puts "\nTriangles with an area of: #{area}"
sorted.each{|tr| puts tr if tr.area == area}
