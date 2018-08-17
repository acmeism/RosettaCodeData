# Project : Doubly-linked list/Definition

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
