words = ["133252abcdeeffd", "a6789798st", "yxcdfgxcyz"]

counter = words.inject({}){|h, word| word.chars.tally(h)}
puts counter.filter_map{|char, count| char if count == 1}.sort.join
