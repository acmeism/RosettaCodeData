require "big"

ar = [0, 2, -4].map(&.to_big_r)

100.times { ar << (111 - 1130.to_big_r / ar[-1] + 3000.to_big_r / (ar[-1] * ar[-2])) }

[3, 4, 5, 6, 7, 8, 20, 30, 50, 100].each do |n|
  puts "%3d -> %0.16f" % [n, ar[n]]
end
