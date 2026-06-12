var list1 = (1..9).toList
var list2 = (10..18).toList
var list3 = (19..27).toList
var list  = (0..8).map { |i| 1e4*list1[i] + 100*list2[i] + list3[i] }.toList
System.print(list)
