require "prime"

puts Prime.each(5000).select{|p| 2.pow(p-1 ,p*p) == 1 }
