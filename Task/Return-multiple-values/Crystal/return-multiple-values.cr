def rmv
  # with the 'return' keyword you don't need brackets around the tuple
  # these are equivalent:
  #  return 1, 2, 3
  #  return {1, 2, 3}
  #  {1, 2, 3}   # (as the last evaluated expression)
  return 1, 2, 3
end

a, b, c = rmv
puts "tuple elements are assigned in order"
p! a, b, c
puts
a, b = rmv
puts "non-assigned elements are discarded"
p! a, b
puts
a = rmv
puts "except when the assignment is to only one variable"
p! a
