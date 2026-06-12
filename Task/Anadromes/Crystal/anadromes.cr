words = File.read_lines("words.txt").select {|w| w.size > 6 }.to_set

words.compact_map {|word|
  reversed = word.reverse
  if word < reversed && words.includes?(reversed)
    word
  end
}.sort!.each do |anadrome|
  printf "%-10s %s\n", anadrome, anadrome.reverse
end
