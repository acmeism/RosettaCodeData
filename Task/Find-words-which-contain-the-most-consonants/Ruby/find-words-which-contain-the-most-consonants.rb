filtered = File.open("unixdict.txt").each( chomp: true).select do |word|
  next unless word.size > 10
  cons = word.delete('aeiou')
  cons.chars.uniq.join == cons
end

grouped = filtered.group_by{|word| word.count('^aeiou')}
grouped.sort_by{|k,v| -k}.each do |chunk|
  puts"\n#{chunk.first} consonants (#{chunk.last.size}):"
  puts chunk.last.first(10)
  puts "..." if chunk.last.size > 10
end
