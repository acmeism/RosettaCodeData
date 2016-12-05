alist = [7,6,5,9,8,4,3,1,2,0]
see insertionsort(alist)

func insertionsort blist
     for i = 1 to len(blist)
         value = blist[i]
         j = i - 1
         while j >= 1 and blist[j] > value
               blist[j+1] = blist[j]
               j = j - 1
         end
         blist[j+1] = value
      next
      return blist
