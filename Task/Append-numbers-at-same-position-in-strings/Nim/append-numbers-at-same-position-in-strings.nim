import std/strutils

const
  List1 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  List2 = [10, 11, 12, 13, 14, 15, 16, 17, 18]
  List3 = [19, 20, 21, 22, 23, 24, 25, 26, 27]

var list: array[List1.len, int]
for i in 0..list.high:
  list[i] = parseInt($List1[i] & $List2[i] & $List3[i])

echo "list = ", list
