def lookandsay(str)
  str.gsub(/(.)\1*/) { |s| s.size.to_s + $1 }
end

num = "1"
12.times { puts num;  num = lookandsay(num) }
