def lookandsay(str)
  str.chars.chunks(&.itself).map{ |(c, x)| x.size.to_s + c }.join
end

num = "1"
12.times { puts num; num = lookandsay(num) }
