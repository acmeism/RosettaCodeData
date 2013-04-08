(1..100).each do |n|
  v = "#{"Fizz" if n % 3 == 0}#{"Buzz" if n % 5 == 0}"
  puts v.empty? ? n : v
end
