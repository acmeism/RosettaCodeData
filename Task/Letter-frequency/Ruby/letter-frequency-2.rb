def letter_frequency(file)
  freq = Hash.new(0)
  file.each_char.lazy.grep(/[[:alpha:]]/).map(&:upcase).each_with_object(freq) do |char, freq_map|
    freq_map[char] += 1
  end
end

letter_frequency(ARGF).sort.each do |letter, frequency|
  puts "#{letter}: #{frequency}"
end
