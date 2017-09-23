def self_describing?(n)
  digits = n.digits.reverse
  digits.each_with_index.all?{|digit, idx| digits.count(idx) == digit}
end

3_300_000.times {|n| puts n if self_describing?(n)}
