str = "abracadabra"
rules = [
  ["a", 1, "A"],
  ["a", 2, "B"],
  ["a", 4, "C"],
  ["a", 5, "D"],
  ["b", 1, "E"],
  ["r", 2, "F"]]

indices = Hash.new{[]}
str.each_char.with_index{|c, i| indices[c] <<= i}

rules.each{|char, i, to| str[indices[char][i-1]] = to}

p str
