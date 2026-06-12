list   =   [1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3]

max_dif, pairs =  list.each_cons(2).group_by{|a,b| (a-b).abs}.max

puts "Maximum difference is #{max_dif}:"
pairs.each{|pair| p pair}
