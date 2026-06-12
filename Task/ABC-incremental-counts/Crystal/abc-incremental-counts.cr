def incrementing? (word, letters, minimum)
  seq = word.chars.tally.select! { |k, v| letters.includes? k }.values.sort!
  seq.size == letters.size && seq[0] >= minimum && seq.each_cons_pair.all? {|a, b| a + 1 == b }
end

["unixdict.txt", "words_alpha.txt"].each_with_index do |dict, i|
  lines = File.read_lines(dict)
  [{"abc", 1 + i}, {"the", 1 + i}, {"cio", 2 + i}].each do |letters, min|
    letters = letters.chars.to_set
    puts "Dictionary: #{dict}, letters: <#{letters.join(" ")}>, minimum: #{min}"
    puts "  " + lines.select {|word| incrementing? word, letters, min }.join("\n  ")
  end
end
