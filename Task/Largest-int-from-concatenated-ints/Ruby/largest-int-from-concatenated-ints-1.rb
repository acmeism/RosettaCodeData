def icsort nums
  nums.sort { |x, y| "#{y}#{x}" <=> "#{x}#{y}" }
end

[[54, 546, 548, 60], [1, 34, 3, 98, 9, 76, 45, 4]].each do |c|
  p c # prints nicer in Ruby 1.8
  puts icsort(c).join
end
