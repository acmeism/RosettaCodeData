require 'prime'

Prime.each(30).to_a.combination(3).select{|trio| trio.sum.prime? }.each do |a,b,c|
  puts "#{a} + #{b} + #{c} = #{a+b+c}"
end

m = 1000
count = Prime.each(m).to_a.combination(3).count{|trio| trio.sum.prime? }
puts "Count of strange unique prime triplets < #{m} is #{count}."
