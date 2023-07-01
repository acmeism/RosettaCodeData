def generate_statistics(n)
  sum = sum2 = 0.0
  hist = Array.new(10, 0)
  n.times do
    r = rand
    sum += r
    sum2 += r**2
    hist[(10*r).to_i] += 1
  end
  mean = sum / n
  stddev = Math::sqrt((sum2 / n) - mean**2)

  puts "size: #{n}"
  puts "mean:   #{mean}"
  puts "stddev: #{stddev}"
  hist.each_with_index {|x,i| puts "%.1f:%s" % [0.1*i, "=" * (70*x/hist.max)]}
  puts
end

[100, 1000, 10000].each {|n| generate_statistics n}
