require 'prime'

sum = 0
Prime.each(1000).with_index(1).each_slice(2) do |(odd_i, i),(_)|
  puts "%6d%6d%6d" % [i, odd_i, sum] if (sum += odd_i).prime?
end
