require 'rational' #Only needed in Ruby < 1.9

def icsort nums
  nums.sort_by { |i| Rational(i, 10**(Math.log10(i).to_i+1)-1) }.reverse
end

[[54, 546, 548, 60], [1, 34, 3, 98, 9, 76, 45, 4]].each do |c|
  p c # prints nicer in Ruby 1.8
  puts icsort(c).join
end
