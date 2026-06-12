require 'prime'

p (1..100).select{|n|(n*n).digits.sum.prime? && (n**3).digits.sum.prime?}
