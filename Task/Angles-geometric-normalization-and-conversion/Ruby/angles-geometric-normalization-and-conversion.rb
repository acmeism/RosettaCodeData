module Angles
  BASES = {"d" => 360, "g" => 400, "m" => 6400, "r" => Math::PI*2 ,"h" => 24 }

  def self.method_missing(meth, angle)
    from, to = BASES.values_at(*meth.to_s.split("2"))
    raise NoMethodError, meth if (from.nil? or to.nil?)
    mod = (angle.to_f * to / from) % to
    angle < 0 ? mod - to : mod
  end

end

#Demo
names = Angles::BASES.keys
puts " " + "%12s "*names.size % names
test = [-2, -1, 0, 1, 2*Math::PI, 16, 360/(2*Math::PI), 360-1, 400-1, 6400-1, 1_000_000]

test.each do |n|
  names.each do |first|
    res = names.map{|last| Angles.send((first + "2" + last).to_sym, n)}
    puts first + "%12g "*names.size % res
  end
  puts
end
