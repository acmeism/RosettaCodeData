DIGITS = (0..9).to_a
range  = (3..18)

res = range.map do |s|
  powers = {}
  DIGITS.each{|n| powers[n] = n**s}
  DIGITS.repeated_combination(s).filter_map do |combi|
    sum = powers.values_at(*combi).sum
    sum if sum.digits.sort == combi.sort
  end.sort
end

puts "Own digits power sums for N = #{range}:", res
