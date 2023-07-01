# Project: Primorial numbers
load "bignumber.ring"
decimals(0)
num = 0
prim = 0
limit = 10000000
see "working..." + nl
see "wait for done..." + nl
while num < 100001
    prim = prim + 1
    prime = []
    primorial(prim)
end
see "done..." + nl

func primorial(pr)
     n = 1
     n2 = 0
     flag = 1
     while flag = 1 and n < limit
           nr = isPrime(n)
           if n=1
              nr=1
           ok
           if nr=1
              n2 = n2 + 1
              add(prime,n)
           ok
           if n2=pr
              flag=0
              num = num + 1
           ok
           n = n + 1
     end
     pro = 1
     str = ""
     for n=1 to len(prime)
         pro = FuncMultiply("" + pro,"" + prime[n])
         str = str + prime[n] + "*"
     next
     str = left(str,len(str)-1)
     if pr < 11
        see "primorial(" + string(pr-1) + ") : " + pro + nl
     ok
     if pr = 11
        see "primorial(" + string(pr-1) + ") " + "has " + len(pro) + " digits"+ nl
     but pr = 101
        see "primorial(" + string(pr-1) + ") " + "has " + len(pro) + " digits"+ nl
     but pr = 1001
         see "primorial(" + string(pr-1) + ") " + "has " + len(pro) + " digits"+ nl
     but pr = 10001
         see "primorial(" + string(pr-1) + ") " + "has " + len(pro) + " digits"+ nl
     but pr = 100001
         see "primorial(" + string(pr-1) + ") " + "has " + len(pro) + " digits"+ nl
     ok
