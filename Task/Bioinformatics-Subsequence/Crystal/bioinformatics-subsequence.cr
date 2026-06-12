class String
  def indices (search, offset = 0)
    result = [] of Int32
    while idx = index(search, offset)
      result << idx
      offset = idx + 1
    end
    result
  end
end

def make_random_sequence (length)
  bases = ['A', 'T', 'C', 'G']
  String.build do |s|
    length.times do
      s << bases.sample
    end
  end
end

haystack = make_random_sequence 400
needle = make_random_sequence 4

indices = haystack.indices needle

# task is already done, next is only fancy display code
print "     "
(0..4).each do |d| printf "%-10d", d end
print "    \"#{needle}\""
print "\n     ", ((0..9).to_a * 5).join, "   found at"
print "\n     ", "-"*61, "\n"
haystack.chars.each_slice(50).each_with_index do |row, n|
  printf "%4d %-50s   ", n*50, row.join
  puts indices.select {|idx| n*50 <= idx < (n+1)*50 }.join(" ")
end
