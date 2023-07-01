# Project : Cartesian product of two or more lists

list1 = [[1,2],[3,4]]
list2 = [[3,4],[1,2]]
cartesian(list1)
cartesian(list2)

func cartesian(list1)
     for n = 1 to len(list1[1])
         for m = 1 to len(list1[2])
             see "(" + list1[1][n] + ", " + list1[2][m] + ")" + nl
         next
      next
      see nl
