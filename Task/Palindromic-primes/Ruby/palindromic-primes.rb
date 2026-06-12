require 'prime'

p Prime.each(1000).select{|pr| pr.digits == pr.digits.reverse}
