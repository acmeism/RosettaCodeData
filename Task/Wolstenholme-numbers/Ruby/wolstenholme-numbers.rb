require 'prime'

res = (1..20).each.inject([0]){|memo, n| memo << memo.last + (1r/(n*n))}
wolstenholmes = res.map(&:numerator)[1..]
wolstenholmes_primes = wolstenholmes.select(&:prime?)

[wolstenholmes, wolstenholmes_primes].each do |whs|
  whs.each.with_index(1){|n, i|  puts "%-3d: %d" % [i, n] }
  puts
end
