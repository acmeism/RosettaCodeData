a, b = "Given two strings", "of different length"
[a,b].sort_by{|s| - s.size }.each{|s| puts s + " (size: #{s.size})"}

list = ["abcd","123456789","abcdef","1234567"]
puts list.sort_by{|s|- s.size}
