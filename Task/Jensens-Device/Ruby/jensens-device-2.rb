def sum2(lo, hi)
  lo.upto(hi).inject(0.0) {|sum, n| sum += yield n}
end
p sum2(1, 100) {|i| 1.0/i}  # => 5.18737751763962
