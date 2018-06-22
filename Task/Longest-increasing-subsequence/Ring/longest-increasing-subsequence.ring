# Project : Longest increasing subsequence
# Date    : 2017/11/23
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

tests = [[3, 2, 6, 4, 5, 1], [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]]
res = []
for x=1 to len(tests)
    lis(tests[x])
    showarray(res)
end

func lis(X)
     N = len(X)
     P = list(N)
     M = list(N)
     for nr = 1 to len(P)
         P[nr] = 0
     next
     for nr = 1 to len(M)
         P[nr] = 0
     next
     len = 0
     for i=1 to N
         lo = 1
         hi = len
         while lo <= hi
               mid = floor((lo+hi)/2)
               if X[M[mid]]<X[i]
                  lo = mid + 1
               else
                  hi = mid - 1
               ok
         end
         if lo>1
            P[i] = M[lo-1]
         ok
         M[lo] = i
         if lo>len
            len = lo
         ok
     next
     res = list(len)
     if len>0
        k = M[len]
        for i=len to 1 step -1
            res[i] = X[k]
            k = P[k]
        next
     ok
     return res

func showarray(vect)
     see "{"
     svect = ""
     for n = 1 to len(vect)
         svect = svect + vect[n] + ", "
     next
     svect = left(svect, len(svect) - 2)
     see svect
     see "}" + nl
