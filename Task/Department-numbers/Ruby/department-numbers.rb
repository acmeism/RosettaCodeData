(1..7).to_a.permutation(3){|p| puts p.join if p.first.even? && p.sum == 12 }
