def entropy(s)
  counts = s.chars.each_with_object(Hash(Char, Float64).new(0.0)) { |c, h| h[c] += 1 }
  counts.values.sum do |count|
    freq = count / s.size
    -freq * Math.log2(freq)
  end
end

puts entropy File.read(__FILE__)
