require "prime"

concats =  Prime.each(100).to_a.repeated_permutation(2).filter_map do |pair|
  p1p2 = pair.map(&:to_s).join.to_i
  p1p2 if p1p2.prime?
end
concats = concats.sort.uniq

concats.each_slice(10){|slice|puts slice.map{|el| el.to_s.ljust(6)}.join }
