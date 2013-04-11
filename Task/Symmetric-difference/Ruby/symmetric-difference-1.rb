# with sets
require 'set'
a = Set["John", "Serena", "Bob", "Mary", "Serena"]
b = Set["Jim", "Mary", "John", "Jim", "Bob"]

# or, with arrays
a = ["John", "Serena", "Bob", "Mary", "Serena"]
b = ["Jim", "Mary", "John", "Jim", "Bob"]
a.uniq!
b.uniq!
