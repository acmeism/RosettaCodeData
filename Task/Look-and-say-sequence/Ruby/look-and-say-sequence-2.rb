def lookandsay(str)
  str.chars.chunk{|c| c}.map{|c,x| [x.size, c]}.join
end

puts num = "1"
9.times do
  puts num = lookandsay(num)
end
