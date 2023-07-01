def entropy(s)
  counts = s.chars.tally
  leng = s.length.to_f
	
  counts.values.reduce(0) do |entropy, count|
    freq = count / leng
    entropy - freq * Math.log2(freq)
  end
end

p entropy("1223334444")
