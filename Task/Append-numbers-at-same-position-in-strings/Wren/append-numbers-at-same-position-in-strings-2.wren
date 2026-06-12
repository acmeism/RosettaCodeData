var list1 = (1..9).toList
var list2 = (10..18).toList
var list3 = (19..27).toList
var list  = (0..8).map { |i| list1[i].toString + list2[i].toString + list3[i].toString }.toList
System.print(list)
