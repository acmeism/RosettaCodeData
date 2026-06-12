require 'prime'

p Prime.each(500).each_cons(2).select{|p, q| (p*q+2).prime? }
