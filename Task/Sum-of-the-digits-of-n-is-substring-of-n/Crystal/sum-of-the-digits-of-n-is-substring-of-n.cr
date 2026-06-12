p (0...1000).select { |n| n.digits.sum.to_s.in? n.to_s }.to_a
