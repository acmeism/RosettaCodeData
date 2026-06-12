p (0..10_000).select{|n| (n*n).to_s.end_with? n.to_s }
