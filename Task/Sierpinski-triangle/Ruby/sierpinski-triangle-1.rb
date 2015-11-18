ruby -le'16.times{|y|print" "*(15-y),*(0..y).map{|x|~y&x>0?"  ":" *"}}'
