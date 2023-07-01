def curzons(k)
  Enumerator.new do |y|
    (1..).each do |n|
      r = k * n
      y << n if k.pow(n, r + 1) == r
    end
  end
end

[2,4,6,8,10].each do |base|
  puts "Curzon numbers with k = #{base}:"
  puts curzons(base).take(50).join(", ")
  puts "Thousandth Curzon with k = #{base}: #{curzons(base).find.each.with_index(1){|_,i| i == 1000} }",""
end
