def is_self_describing?(n)
  digits = n.to_s.chars.map(&:to_i)
  digits.each_with_index.all?{|digit, idx| digits.count(idx) == digit}
end

3_300_000.times {|n| puts n if is_self_describing?(n)}
