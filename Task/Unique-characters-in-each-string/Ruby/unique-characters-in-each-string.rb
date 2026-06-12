arr = ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]

uniqs_in_str = arr.map{|str| str.chars.tally.filter_map{|char, count| char if count == 1} }
puts uniqs_in_str.inject(&:intersection).sort.join(" ")
