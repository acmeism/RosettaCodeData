#encoding: ASCII-8BIT

def entropy(s)
  counts = Hash.new(0.0)
  s.each_char { |c| counts[c] += 1 }
  leng = s.length

  counts.values.reduce(0) do |entropy, count|
    freq = count / leng
    entropy - freq * Math.log2(freq)
  end
end

n_max = 37
words = ['1', '0']

for n in words.length ... n_max
  words << words[-1] + words[-2]
end

puts '%3s %9s %15s  %s' % %w[N Length Entropy Fibword]
words.each.with_index(1) do |word, i|
  puts '%3i %9i %15.12f  %s' % [i, word.length, entropy(word), word.length<60 ? word : '<too long>']
end
