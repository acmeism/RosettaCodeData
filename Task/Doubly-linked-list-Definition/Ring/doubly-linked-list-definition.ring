# Project : Doubly-linked list/Definition
# Date    : 2018/01/08
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

test = [1, 5, 7, 0, 3, 2]
insert(test, 0, 9)
insert(test, len(test), 4)
item = len(test)/2
insert(test, item, 6)
showarray(test)

func showarray(vect)
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + " "
        next
        svect = left(svect, len(svect) - 1)
        see svect
