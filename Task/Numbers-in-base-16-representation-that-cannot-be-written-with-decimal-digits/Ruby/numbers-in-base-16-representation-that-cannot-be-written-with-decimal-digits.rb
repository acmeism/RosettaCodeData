p (0..500).select{|n| n.digits(16).all?{|d| d > 9} }
