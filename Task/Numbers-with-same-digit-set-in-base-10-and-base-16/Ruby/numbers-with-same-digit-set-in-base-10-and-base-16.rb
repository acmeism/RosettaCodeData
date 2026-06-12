p (1..100_000).select{|n| n.digits.to_set == n.digits(16).to_set}
