list1 = (1..9)  .to_a
list2 = (10..18).to_a
list3 = (19..27).to_a

p list = [list1, list2, list3].transpose.map{|trio| trio.join.to_i }
