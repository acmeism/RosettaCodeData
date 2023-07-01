# Project : Leanardo numbers

n0 = 1
n1 = 1
add = 1
see "First 25 Leonardo numbers:" + nl
leonardo()
n0 = 1
n1 = 1
add = 0
see "First 25 Leonardo numbers with L(0) = 0, L(1) = 1, step = 0 (fibonacci numbers):" + nl
see "" + add + " "
leonardo()

func leonardo()
        see "" + n0 + " " + n1
        for i=3 to 25
              temp=n1
              n1=n0+n1+add
              n0=temp
             see " "+ n1
        next
        see nl
