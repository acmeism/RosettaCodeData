lo, hi = 100, 1000
(Integer.sqrt(lo)..Integer.sqrt(hi)).each{|n| puts n*n if n.odd?}
