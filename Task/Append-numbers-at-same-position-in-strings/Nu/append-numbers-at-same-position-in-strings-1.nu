const list1 = [1 2 3 4 5 6 7 8 9]
const list2 = [10 11 12 13 14 15 16 17 18]
const list3 = [19 20 21 22 23 24 25 26 27]

[$list1 $list2 $list3] | each { into record } | values | each { str join }
