set values {7 6 5 4 3 2 1 0}
set indices {6 1 7}
puts \[[join [disjointSort $values $indices] ", "]\]
