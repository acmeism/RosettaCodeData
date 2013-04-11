def icsort nums
  maxlen = nums.max.to_s.length
  nums.map{ |x| x.to_s }.sort_by { |x| x * (maxlen * 2 / x.length) }.reverse
end

[[54, 546, 548, 60], [1, 34, 3, 98, 9, 76, 45, 4]].each do |c|
  p c # prints nicer in Ruby 1.8
  puts icsort(c).join
end
