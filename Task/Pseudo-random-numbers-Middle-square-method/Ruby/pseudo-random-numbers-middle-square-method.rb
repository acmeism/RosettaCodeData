def middle_square (seed)
  return to_enum(__method__, seed) unless block_given?
  s = seed.digits.size
  loop { yield seed = (seed*seed).to_s.rjust(s*2, "0")[s/2, s].to_i }
end

puts middle_square(675248).take(5)
