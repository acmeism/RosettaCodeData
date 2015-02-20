class String
  def digroot_persistence(base=10)
    num = self.to_i(base)
    persistence = 0
    until num < base do
      num = num.to_s(base).each_char.reduce(0){|m, c| m + c.to_i(base) }
      persistence += 1
    end
    [num.to_s(base), persistence]
  end
end

puts "--- Examples in 10-Base ---"
%w(627615 39390 588225 393900588225).each do |str|
  puts "%12s has a digital root of %s and a persistence of %s." % [str, *str.digroot_persistence]
end
puts "\n--- Examples in other Base ---"
format = "%s base %s has a digital root of %s and a persistence of %s."
[["101101110110110010011011111110011000001", 2],
 [ "5BB64DFCC1", 16],
 ["5", 8],
 ["50YE8N29", 36]].each do |(str, base)|
   puts format % [str, base, *str.digroot_persistence(base)]
end
