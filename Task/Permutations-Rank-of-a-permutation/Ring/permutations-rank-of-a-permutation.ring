# Project : Permutations/Rank of a permutation

list = [0, 1, 2, 3]
for perm = 0 to 23
    str = ""
    for i = 1 to len(list)
        str = str + list[i] + ", "
    next
    see nl
    str = left(str, len(str)-2)
    see "(" + str + ") -> " + perm
    nextPermutation(list)
next

func nextPermutation(a)
     elementcount = len(a)
     if elementcount < 1 then return ok
     pos = elementcount-1
     while a[pos] >= a[pos+1]
           pos -= 1
           if pos <= 0 permutationReverse(a, 1, elementcount)
              return
           ok
     end
     last = elementcount
     while a[last] <= a[pos]
           last -= 1
     end
     temp = a[pos]
     a[pos] = a[last]
     a[last] = temp
     permutationReverse(a, pos+1, elementcount)

 func permutationReverse(a, first, last)
      while first < last
            temp = a[first]
            a[first] = a[last]
            a[last] = temp
            first = first + 1
            last = last - 1
      end
