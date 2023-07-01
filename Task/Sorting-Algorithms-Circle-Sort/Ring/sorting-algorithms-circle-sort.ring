# Project : Sorting Algorithms/Circle Sort

test = [-4, -1, 1, 0, 5, -7, -2, 4, -6, -3, 2, 6, 3, 7, -5]
while circlesort(1, len(test), 0) end
showarray(test)

func circlesort(lo, hi, swaps)
     if lo = hi
        return swaps
     ok
     high = hi
     low = lo
     mid = floor((hi-lo)/2)
     while lo < hi
           if test[lo] > test[hi]
               temp = test[lo]
               test[lo] = test[hi]
               test[hi] = temp
               swaps = swaps + 1
           ok
           lo = lo + 1
           hi = hi - 1
     end
     if lo = hi
        if test[lo] > test[hi+1]
           temp = test[lo]
           test[lo] = test[hi+1]
           test[hi + 1] = temp
           swaps = swaps + 1
        ok
     ok
     swaps = circlesort(low, low+mid, swaps)
     swaps = circlesort(low+mid+1 ,high, swaps)
     return swaps

func showarray(vect)
     see "["
     svect = ""
     for n = 1 to len(vect)
         svect = svect + vect[n] + ", "
     next
     svect = left(svect, len(svect) - 2)
     see svect
     see "]" + nl
