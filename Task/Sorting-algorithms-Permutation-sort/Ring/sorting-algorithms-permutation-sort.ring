# Project : Sorting algorithms/Permutation sort

a = [4, 65, 2, 31, 0, 99, 2, 83, 782]
result = []
permute(a,1)

for n = 1 to len(result)
     num = 0
     for m = 1 to len(result[n]) - 1
          if result[n][m] <= result[n][m+1]
             num = num + 1
          ok
     next
      if num = len(result[n]) - 1
         nr = n
         exit
      ok
next
see "" + nr + " permutations required to sort " + len(a) + " items." + nl

func permute(a,k)
       if k = len(a)
          add(result,a)
       else
          for i = k to len(a)
               temp=a[k]
               a[k]=a[i]
               a[i]=temp
               permute(a,k+1)
               temp=a[k]
               a[k]=a[i]
               a[i]=temp
          next
       ok
       return a
