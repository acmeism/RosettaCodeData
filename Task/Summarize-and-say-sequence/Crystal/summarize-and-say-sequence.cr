def seq_next (s)
  digits = StaticArray(Int32, 10).new(0)
  s.each_char do |ch|
    digits[ch - '0'] += 1
  end
  String.build do |r|
    9.downto(0) do |i|
      r << digits[i].to_s << '0' + i  if digits[i] > 0
    end
  end
end

max_length = 0
seeds = {} of String => Array(Int32)
longest_seqs = {} of String => Array(String)
seen = Set(String).new

(0..1_000_000).each do |i|
  seq = [i.to_s]
  key = n = seq_next(seq.last)
  if key.in? seen
    seeds[key] << i if seeds.has_key?(key)
    next
  end
  seen << key
  while !seq.includes? n
    seq << n
    n = seq_next(n)
  end
  next if seq.size < max_length
  if seq.size > max_length
    max_length = seq.size
    seeds.clear
    longest_seqs.clear
  end
  (seeds[key] ||= [] of Int32) << i
  longest_seqs[key] ||= seq
end

puts "Longest sequence size: #{max_length}"
puts
seeds.keys.each do |k|
  print "Seeds: ", seeds[k].join(" "), "\n"
  puts "Sequence:"
  longest_seqs[k].each do |n|
    print "  ", n, "\n"
  end
  puts
end
