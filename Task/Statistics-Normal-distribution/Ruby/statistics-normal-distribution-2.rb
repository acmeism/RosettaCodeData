require('enumerable/statistics')

def show_stats_and_histogram(data, bins)
  puts("size = #{data.length}  mean = #{data.mean()}  stddev = #{data.stdev()}")
  hist = data.histogram(bins)
  scale = 100.0 / hist.weights.max
  inx_beg = nil
  inx_end = nil
  hist.weights.length.times do |inx|
    histstars = (0.5 + (scale * hist.weights[inx])).to_i
    inx_beg = inx if !inx_beg && (histstars > 0)
    inx_end = inx if (histstars > 0)
  end
  (inx_beg..inx_end).each do |inx|
    bincenter = 0.5 * (hist.edges[inx] + hist.edges[inx + 1])
    histstars = (0.5 + (scale * hist.weights[inx])).to_i
    puts('%6.2f: %s' % [bincenter, '*' * histstars])
  end
end

puts
puts('Uniform random number generator:')
show_stats_and_histogram(1000000.times.map { Random.rand(-1.0..1.0) }, 20)

puts
puts('Normal random numbers using the Marsaglia polar method:')
gen_normal = NormalFromUniform.new
show_stats_and_histogram(100.times.map { gen_normal.rand }, 40)
show_stats_and_histogram(10000.times.map { gen_normal.rand }, 60)
show_stats_and_histogram(1000000.times.map { gen_normal.rand }, 120)
