# Project : Longest string challenge
# Date    : 2017/10/11
# Author  : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"

test = ["a", "bb", "ccc", "ddd", "ee", "f", "ggg"]
test1 = []
test2 = []

for n = 1 to len(test)
    add(test1, [test[n], len(test[n])])
next
sortFirstSecond(test1, 2)

for n = len(test1) to 2 step -1
    if test1[n][2] = test1[n-1][2]
      add(test2, test1[n][1])
    else
      add(test2, test1[n][1])
      exit
    ok
next
test2 = sort(test2)
see test2 + nl
