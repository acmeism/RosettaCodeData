def lookandsay(str)
   str.gsub(/(.)\1*/) {$&.length.to_s + $1}
end

num = "1"
10.times do
    puts num
    num = lookandsay(num)
end
