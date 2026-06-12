new_word_size = 9
well_sized  = File.readlines("unixdict.txt", chomp: true).reject{|word| word.size < new_word_size}
list = well_sized.each_cons(new_word_size).filter_map do |slice|
  candidate = (0...new_word_size).inject(""){|res, idx| res << slice[idx][idx] }
  candidate if well_sized.include?(candidate)
end
puts list.uniq
