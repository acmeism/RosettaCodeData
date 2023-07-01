# Only if 'input.txt' is a text file!
# Only if pipe '|' is not first character of path!
str = IO.read('input.txt')
open('output.txt', 'w') {|f| f.write str}
