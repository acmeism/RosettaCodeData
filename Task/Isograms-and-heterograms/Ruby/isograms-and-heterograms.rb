words = File.readlines("unixdict.txt", chomp: true)

isograms = words.group_by do |word|
  char_counts = word.downcase.chars.tally.values
  char_counts.first if char_counts.uniq.size == 1
end
isograms.delete(nil)
isograms.transform_values!{|ar| ar.sort_by{|word| [-word.size, word]} }

keys = isograms.keys.sort.reverse
keys.each{|k| puts "(#{isograms[k].size}) #{k}-isograms: #{isograms[k]} " if k > 1 }

min_chars = 10
large_heterograms = isograms[1].select{|word| word.size > min_chars }
puts "" , "(#{large_heterograms.size}) heterograms with more than #{min_chars} chars:"
puts large_heterograms
