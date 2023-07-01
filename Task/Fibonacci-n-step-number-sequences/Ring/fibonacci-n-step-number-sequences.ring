# Project : Fibonacci n-step number sequences

f = list(12)

see "Fibonacci:" + nl
f2  = [1,1]
for nr2 = 1 to 10
    see "" + f2[1] + " "
    fibn(f2)
next
showarray(f2)
see " ..." + nl + nl

see "Tribonacci:" + nl
f3 = [1,1,2]
for nr3 = 1 to 9
    see "" + f3[1] + " "
    fibn(f3)
next
showarray(f3)
see " ..." + nl + nl

see "Tetranacci:" + nl
f4 = [1,1,2,4]
for nr4 = 1 to 8
    see "" + f4[1] + " "
    fibn(f4)
next
showarray(f4)
see " ..." + nl + nl

see "Lucas:" + nl
f5 = [2,1]
for nr5 = 1 to 10
    see "" + f5[1] + " "
    fibn(f5)
next
showarray(f5)
see " ..." + nl + nl

func fibn(fs)
     s = sum(fs)
     for i = 2 to len(fs)
         fs[i-1] = fs[i]
     next
     fs[i-1] = s
     return fs

func sum(arr)
     sm = 0
     for sn = 1 to len(arr)
         sm = sm + arr[sn]
     next
     return sm

func showarray(fn)
     svect = ""
     for p = 1 to len(fn)
         svect = svect + fn[p] + " "
     next
     see svect
