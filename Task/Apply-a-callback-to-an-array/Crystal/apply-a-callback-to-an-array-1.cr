values = [1, 2, 3]

new_values = values.map do |number|
  number * 2
end

puts new_values  #=> [2, 4, 6]
