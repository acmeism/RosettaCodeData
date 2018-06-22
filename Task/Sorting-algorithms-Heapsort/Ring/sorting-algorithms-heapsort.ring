# Project : Sorting algorithms/Heapsort
# Date    : 2018/03/04
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

test = [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]
see "before sort:" + nl
showarray(test)
heapsort(test)
see "after sort:" + nl
showarray(test)

func heapsort(a)
cheapify(a)
for e = len(a) to 1 step -1
     temp = a[e]
     a[e] = a[1]
     a[1] = temp
     siftdown(a, 1, e-1)
next

func cheapify(a)
m = len(a)
for s = floor((m - 1) / 2) to 1 step -1
     siftdown(a,s,m)
next

func siftdown(a,s,e)
r = s
while r * 2 + 1 <= e
         c = r * 2
         if c + 1 <= e
            if a[c] < a[c + 1]
               c = c + 1
            ok
         ok
         if a[r] < a[c]
            temp = a[r]
            a[r] = a[c]
            a[c] = temp
            r = c
         else
            exit
         ok
end

func showarray(vect)
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + " "
        next
        svect = left(svect, len(svect) - 1)
        see svect + nl
