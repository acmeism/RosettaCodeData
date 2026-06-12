p "Rosetta Code is a programming chrestomathy site".split.sort_by(&:size)
# sort by word-size, then lexical:
str = "Rosetta Code is a programming chrestomathy site seven extra words added to this demo"
p str.split.sort_by{|word| [word.size, word]}
