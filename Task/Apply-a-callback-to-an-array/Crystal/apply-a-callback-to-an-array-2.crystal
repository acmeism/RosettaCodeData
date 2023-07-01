values = [1, 2, 3]

def double(number)
  number * 2
end

# the `->double(Int32)` syntax creates a proc from a function/method. argument types must be specified.
# the `&proc` syntax passes a proc as a block.
# combining the two passes a function/method as a block
new_values = values.map &->double(Int32)

puts new_values  #=> [2, 4, 6]
