(1..7).to_a.each_permutation(3, true) { |p| puts p.join if p.first.even? && p.sum == 12 }
