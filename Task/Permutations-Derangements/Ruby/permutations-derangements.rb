def derangements(n)
  ary = (1 .. n).to_a
  ary.permutation.select do |perm|
    ary.zip(perm).all? {|a,b| a != b}
  end
end

def subfact(n)
  case n
  when 0 then 1
  when 1 then 0
  else (n-1)*(subfact(n-1) + subfact(n-2))
  end
end

(0..9).each do |n|
  s = subfact(n)
  if n <= 4
    d = derangements(n)
    puts "n=%d, subfact=%d, num_derangements=%d, %s" % [n, s, d.length, d]
  else
    puts "n=%d, subfact=%d" % [n, s]
  end
end
puts "n=20, subfact=#{subfact(20)}"
