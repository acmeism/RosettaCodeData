require "prime"

Prime.each(1_000_000).each_cons(2) do |a, b|
  diff = b - a
  next unless diff > 36
  isqrt = Integer.sqrt(diff)
  puts "#{b} - #{a} = #{diff}" if isqrt*isqrt == diff
end
