require 'prime'
p (1..200).filter_map{|n| cand = n**3 + 2; cand if cand.prime? }
