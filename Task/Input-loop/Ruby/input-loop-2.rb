# Create an array of lengths of every line.
ary = stream.map {|line| line.chomp.length}
