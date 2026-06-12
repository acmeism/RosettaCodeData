is_vile = ->(n) { Math.log2(n & -n).to_i.even? }
vile = (1..).lazy.select(&is_vile)
dopey = (1..).lazy.reject(&is_vile)

puts "First 25 Vile numbers:\n#{vile.first(25)}\n\n"
puts "First 25 Dopey numbers:\n#{dopey.first(25)}\n\n"
puts "upto:  Vile  Dopey"

(1..10).map { |i| 1 << i }.each { |j|
  vile_count = vile.take_while { |n| n <= j }.count
  dopey_count = dopey.take_while { |n| n <= j }.count
  puts "%4d: %5d %6d" % [j, vile_count, dopey_count]
}
