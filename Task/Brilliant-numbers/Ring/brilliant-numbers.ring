load "stdlib.ring"

n = 0
num = 0
flag = 0
Result = []
while true
    n = n + 1
    deco = []
    prime = n
    decomp1(deco,prime)
    decomp2()
    decomp3()
    if flag = 1
       add(Result,prime)
       if num = 100
          exit
       ok
    ok
end

for n = 1 to len(Result)
    if len(string(Result[n])) = 1
       see "    " + Result[n]
    ok
    if len(string(Result[n])) = 2
       see "   " + Result[n]
    ok
    if len(string(Result[n])) = 3
       see "  " + Result[n]
    ok
    if len(string(Result[n])) = 4
       see " " + Result[n]
    ok
    if n%10 = 0
       see nl
    ok
next

n = 0
num = 0
flag = 0
Sem = List(6)
for s = 1 to len(Sem)
    Sem[s] = 1
next
Latin = []
Result = []
while true
    n = n + 1
    deco = []
    prime = n
    decomp1(deco,prime)
    decomp2()
    decomp3()
    if flag = 1
       add(Result,prime)
       if prime > pow(10,6)
          for p = 1 to len(Result)
              if Result[p] > pow(10,1) and Sem[1] = 1
                 see "" + Result[p] + " is a brilliant number: " + p + nl
                 Sem[1] = 0
              ok

              if Result[p] > pow(10,2) and Sem[2] = 1
                 see "" + Result[p] + " is a brilliant number: " + p + nl
                 Sem[2] = 0
              ok

              if Result[p] > pow(10,3) and Sem[3] = 1
                 see "" + Result[p] + " is a brilliant number: " + p + nl
                 Sem[3] = 0
              ok

              if Result[p] > pow(10,4) and Sem[4] = 1
                 see "" + Result[p] + " is a brilliant number: " + p + nl
                 Sem[4] = 0
              ok

              if Result[p] > pow(10,5) and Sem[5] = 1
                 see "" + Result[p] + " is a brilliant number: " + p + nl
                 Sem[5] = 0
              ok
              if Result[p] > pow(10,6) and Sem[6] = 1
                 see "" + Result[p] + " is a brilliant number: " + p + nl
                 Sem[6] = 0
              ok
           next
       ok
    ok
end

func decomp1(deco,nr)
x = ""
for i = 1 to nr
    if isPrime(i) and nr % i = 0
       add(deco,i)
    ok
next

func decomp2()
while true
      pro = 1
      for n = 1 to len(deco)
          pro = pro * deco[n]
      next
      if pro != prime
         temp = prime/pro
         decomp1(deco,temp)
      else
         exit
      ok
end

func decomp3()
     deco = sort(deco)
     if len(deco) = 2 and prime = deco[1] * deco[2] and
        len(string(deco[1])) = len(string(deco[2]))
        num = num + 1
        flag = 1
     else
        flag = 0
     ok
     if flag = 1
        return num
     ok
