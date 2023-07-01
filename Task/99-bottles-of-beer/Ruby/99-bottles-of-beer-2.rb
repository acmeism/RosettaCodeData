trace_var :$bottle_num do |val|
  $bottles = %Q{#{val == 0 ? 'No more' : val.to_s} bottle#{val == 1 ? '' : 's'}}
end

($bottle_num = 99).times do
  puts "#{$bottles} of beer on the wall"
  puts "#{$bottles} of beer"
  puts "Take one down, pass it around"
  $bottle_num -= 1
  puts "#{$bottles} of beer on the wall"
  puts ""
end
