pieces = %i(♔ ♕ ♘ ♘ ♗ ♗ ♖ ♖)
regexes = [/♗(..)*♗/, /♖.*♔.*♖/]
row = pieces.shuffle.join until regexes.all?{|re| re.match(row)}
puts row
