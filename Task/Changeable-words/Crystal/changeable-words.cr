words = File.open("unixdict.txt") do |f|
  f.each_line.select {|line| line.size > 11 }.map(&.chars).to_set
end

words.each do |word|
  changed = word.dup
  changed.each_with_index do |ch, i|
    ('a'..'z').each do |new_ch|
      if ch != new_ch
        changed[i] = new_ch
        puts "#{word.join} - #{changed.join}" if changed.in?(words) &&
                                                 changed > word
      end
    end
    changed[i] = ch
  end
end
