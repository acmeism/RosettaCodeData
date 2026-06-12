require 'prime'

Prime.each(100).each_cons(2).select{|p1, p2|(p1+p2-1).prime?}.each{|ar| p ar}
