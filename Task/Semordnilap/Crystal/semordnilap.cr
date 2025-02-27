words = File.read("unixdict.txt").each_line.to_set
semordnilap = words.compact_map {|word|
  reversed = word.reverse
  if word < reversed && words.includes? reversed
    { word, reversed }
  end
}
p semordnilap.size, semordnilap.sample(5)
