#Project: Anbundant odd numbers

max = 100000000
limit = 25
nr = 0
m = 1
check = 0
index = 0
see "working..." + nl
see "wait for done..." + nl
while true
      check = 0
      if m%2 = 1
         nice(m)
      ok
      if check = 1
         nr = nr + 1
      ok
      if nr = max
         exit
      ok
      m = m + 1
end
see "done..." + nl

func nice(n)
     check = 0
     nArray = []
     for i = 1 to n - 1
         if n % i = 0
            add(nArray,i)
         ok
     next
     sum = 0
     for p = 1 to len(nArray)
         sum = sum + nArray[p]
     next
     if sum > n
        check = 1
        index = index + 1
        if index < limit + 1
           showArray(n,nArray,sum,index)
        ok
        if index = 100
           see "One thousandth abundant odd number:" + nl
           showArray2(n,nArray,sum,index)
        ok
        if index = 100000000
           see "First abundant odd number above one billion:" + nl
           showArray2(n,nArray,sum,index)
        ok
     ok

func showArray(n,nArray,sum,index)
        see "" + index + ". " + string(n) + ": divisor sum: "
        for m = 1 to len(nArray)
            if m < len(nArray)
               see string(nArray[m]) + " + "
            else
               see string(nArray[m]) + " = " + string(sum) + nl + nl
            ok
        next

func showArray2(n,nArray,sum,index)
        see "" + index + ". " + string(n) + ": divisor sum: " +
        see string(nArray[m]) + " = " + string(sum) + nl + nl
