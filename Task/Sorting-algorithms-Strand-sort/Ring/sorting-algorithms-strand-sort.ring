# Project : Sorting algorithms/Strand sort
# Date    : 2018/03/04
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

test = [-2,0,-2,5,5,3,-1,-3,5,5,0,2,-4,4,2]
results = []
resultsend = []
see "before sort:" + nl
showarray(test)
test = strandsort(test)
see "after sort:" + nl
showarray(test)

func strandsort(a)
        while len(a) > 0
                 sublist = []
                 add(sublist,a[1])
                 del(a,1)
                 for i = 1 to len(a)
                     if a[i] > sublist[len(sublist)]
                       add(sublist,a[i])
                       del(a,i)
                     ok
                next
                for n = 1 to len(sublist)
                     add(results,sublist[n])
                next
                for n = 1 to len(results)
                     for m = n + 1 to len(results)
                          if results[m] < results[n]
                             temp = results[m]
                             results[m] = results[n]
                             results[n] = temp
                          ok
                     next
                next
        end
        return results

func showarray(vect)
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + " "
        next
        svect = left(svect, len(svect) - 1)
        see svect + nl
