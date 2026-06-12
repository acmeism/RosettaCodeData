require 'prime'
p Prime.each(500).select{|pr| pr.digits.join.to_i.prime? }
