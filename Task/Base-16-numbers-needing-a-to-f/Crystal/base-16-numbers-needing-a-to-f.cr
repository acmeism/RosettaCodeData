puts (0..500).select{|n| n.digits(16).any?{|d| d >= 10} }.join(" ")
