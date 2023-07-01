aList = [3,5,1,2,7,4,8,3,6,4,1]
see combsort(aList)

func combsort t
     gapd = 1.2473
     gap =  len(t)
     swaps = 0
     while gap + swaps > 1
           k = 0
           swaps = 0
           if gap > 1 gap = floor(gap / gapd) ok
           for k = 1 to len(t) - gap
               if t[k] > t[k + gap]
                  temp = t[k]
                  t[k] = t[k + gap]
                  t[k + gap] = temp
                  swaps = swaps + 1 ok
           next
     end
        return t
