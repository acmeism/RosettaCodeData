require 'set'
a = Set["John", "Serena", "Bob", "Mary", "Serena"] #Set removes duplicates
b = Set["Jim", "Mary", "John", "Jim", "Bob"]
p sym_diff = a ^ b # => #<Set: {"Jim", "Serena"}>
