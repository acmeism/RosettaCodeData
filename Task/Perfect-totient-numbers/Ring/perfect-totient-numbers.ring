perfect = []
n = 1
while len(perfect)<20
      totnt = n
      tsum = 0
      while totnt!=1
            totnt = totient(totnt)
            tsum = tsum + totnt
      end
      if tsum=n
         add(perfect,n)
      ok
      n = n + 2
end
see "The first 20 perfect totient numbers are:" + nl
showarray(perfect)

func totient n
     totnt = n
     i = 2
     while i*i <= n
           if n%i=0
              while true
                    n = n/i
                    if n%i!=0
                       exit
                    ok
              end
              totnt = totnt - totnt/i
           ok
           if i=2
              i = i + 1
           else
              i = i + 2
           ok
     end
    if n>1
       totnt = totnt - totnt/n
    ok
    return totnt

func showArray array
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
