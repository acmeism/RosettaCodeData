DIGITS =(1..9).to_a

updowns = Enumerator.new do |y|
  y << 5
  (1..).each do |s|
    perms = DIGITS.repeated_permutation(s)
    perms.each{|perm| y << (perm + perm.reverse.map{|n| 10-n}).join.to_i }
    perms.each{|perm| y << (perm + [5] + perm.reverse.map{|n| 10-n}).join.to_i }
  end
end

res =  updowns.take(5000000)
res.first(50).each_slice(10){|slice| puts "%6d"*slice.size % slice}

puts
n = 500
5.times do
  puts "%8d: %-10d" % [n, res[n-1]]
  n *= 10
end
