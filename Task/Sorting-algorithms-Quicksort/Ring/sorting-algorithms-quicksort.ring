# Project : Sorting algorithms/Quicksort

test = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]
see "before sort:" + nl
showarray(test)
quicksort(test, 1, 10)
see "after sort:" + nl
showarray(test)

func quicksort(a, s, n)
       if n < 2
          return
       ok
       t = s + n - 1
       l = s
       r = t
       p = a[floor((l + r) / 2)]
       while l <= r
               while a[l] < p
                       l = l + 1
               end
               while a[r] > p
                       r = r - 1
               end
               if l <= r
                  temp = a[l]
                  a[l] = a[r]
                  a[r] = temp
                  l = l + 1
                  r = r - 1
              ok
       end
       if s < r
          quicksort(a, s, r - s + 1)
       ok
       if l < t
         quicksort(a, l, t - l + 1 )
       ok

func showarray(vect)
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + " "
        next
        svect = left(svect, len(svect) - 1)
        see svect + nl
