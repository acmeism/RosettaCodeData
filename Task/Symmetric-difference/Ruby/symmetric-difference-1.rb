a = ["John", "Serena", "Bob", "Mary", "Serena"]
b = ["Jim", "Mary", "John", "Jim", "Bob"]
# the union minus the intersection:
p sym_diff = (a | b)-(a & b)  # => ["Serena", "Jim"]
