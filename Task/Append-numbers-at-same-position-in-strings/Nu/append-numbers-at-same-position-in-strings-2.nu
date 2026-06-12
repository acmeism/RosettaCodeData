let list1 = [1 2 3 4 5 6 7 8 9]
let list2 = [10 11 12 13 14 15 16 17 18]
let list3 = [19 20 21 22 23 24 25 26 27]

$list1 | iter zip-with  $list2  {|a, b| ($a | into string)  + ($b | into string) } |
iter zip-with  $list3  {|a, b| ($a | into string)  + ($b | into string) }
