def f(x) x.abs ** 0.5 + 5 * x ** 3 end

puts "Please enter 11 numbers:"
nums = 11.times.map{ gets.to_f }

nums.reverse_each do |n|
  print "f(#{n}) = "
  res = f(n)
  puts res > 400 ? "Overflow!" : res
end
