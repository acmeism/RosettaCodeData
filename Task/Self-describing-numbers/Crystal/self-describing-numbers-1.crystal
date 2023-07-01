def self_describing?(n)
  digits = n.to_s.chars.map(&.to_i)         # 12345 => [1, 2, 3, 4, 5]
  digits.each_with_index.all? { |digit, idx| digits.count(idx) == digit }
end

t = Time.monotonic
600_000_000.times { |n| (puts "#{n} in #{(Time.monotonic - t).total_seconds} secs";\
                        t = Time.monotonic) if self_describing?(n) }
