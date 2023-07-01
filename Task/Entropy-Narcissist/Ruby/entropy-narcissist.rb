def entropy(s)
  counts = s.each_char.tally
  size = s.size.to_f
  counts.values.reduce(0) do |entropy, count|
    freq = count / size
    entropy - freq * Math.log2(freq)
  end
end

s = File.read(__FILE__)
p entropy(s)
