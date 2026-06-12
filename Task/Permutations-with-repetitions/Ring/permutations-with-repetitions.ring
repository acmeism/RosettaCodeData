# Project : Permutations with repetitions

list1 = [["a", "b", "c"], ["a", "b", "c"]]
list2 = [["1", "2", "3"], ["1", "2", "3"]]
permutation(list1)
permutation(list2)

func permutation(list1)
     for n = 1 to len(list1[1])
         for m = 1 to len(list1[2])
             see list1[1][n] + " " + list1[2][m] + nl
         next
     next
     see nl
