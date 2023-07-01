require "big"

ar = [0.to_big_d, 2.to_big_d, -4.to_big_d]

100.times { ar << 111 - 1130.to_big_d.div(ar[-1], 132) + 3000.to_big_d.div((ar[-1] * ar[-2]), 132) }

[3, 4, 5, 6, 7, 8, 20, 30, 50, 100].each do |n|
  puts "%3d -> %0.16f" % [n, ar[n]]
end
