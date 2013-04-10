def entropy(s)
  counts = Hash.new(0)
  s.each_char { |c| counts[c] += 1 }

  counts.values.reduce(0) do |entropy, count|
    freq = count / s.length.to_f
    entropy - freq * Math.log2(freq)
  end
end
