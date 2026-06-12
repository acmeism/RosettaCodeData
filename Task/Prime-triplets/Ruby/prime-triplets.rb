require 'prime'
puts Prime.each(5500).each_cons(3).filter_map{|p1,p2,p3|[p1,p2,p3].join(" ") if p2-p1 == 2 && p3-p1 == 6}
