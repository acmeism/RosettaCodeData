[100, 1000, 10_000].each do |n|
  v = 1
  total_proportion = (1..n).sum do |k|
    v *= k
    digits =  v.digits
    Rational(digits.count(0),  digits.size)
  end
  puts "The mean proportion of 0 in factorials from 1 to #{n} is #{(total_proportion/n).to_f}."
end
