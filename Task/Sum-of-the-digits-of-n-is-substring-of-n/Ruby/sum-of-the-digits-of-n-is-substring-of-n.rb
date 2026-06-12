p (0...1000).select{|n| n.to_s.match? n.digits.sum.to_s}
