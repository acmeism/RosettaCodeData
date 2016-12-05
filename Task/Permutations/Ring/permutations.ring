list = [1, 2, 3, 4]
for perm = 1 to 24
    for i = 1 to len(list)
        see list[i] + " "
    next
    see nl
    nextPermutation(list)
next

func nextPermutation a
     elementcount = len(a)
     if elementcount < 1 then return ok
     pos = elementcount-1
     while a[pos] >= a[pos+1]
           pos -= 1
           if pos <= 0 permutationReverse(a, 1, elementcount)
              return ok
     end
     last = elementcount
     while a[last] <= a[pos]
           last -= 1
     end
     temp = a[pos]
     a[pos] = a[last]
     a[last] = temp
     permutationReverse(a, pos+1, elementcount)

 func permutationReverse a, first, last
      while first < last
            temp = a[first]
            a[first] = a[last]
            a[last] = temp
            first += 1
            last -= 1
      end
