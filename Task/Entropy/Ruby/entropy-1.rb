def entropy(s)
  counts = Hash.new(0.0)
  s.each_char { |c| counts[c] += 1 }
  leng = s.length

  counts.values.reduce(0) do |entropy, count|
    freq = count / leng
    entropy - freq * Math.log2(freq)
  end
end

p entropy("1223334444")
