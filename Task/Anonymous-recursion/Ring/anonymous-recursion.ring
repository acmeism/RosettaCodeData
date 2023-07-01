# Project : Anonymous recursion

t=0
for x = -2 to 12
     n = x
     recursion()
     if x > -1
        see t + nl
     ok
next

func recursion()
        nold1=1
        nold2=0
        if n < 0
           see "positive argument required!" + nl
           return
        ok
        if n=0
           t=nold2
           return t
        ok
        if n=1
           t=nold1
           return  t
        ok
        while n
                  t=nold2+nold1
                  if n>2
                     n=n-1
                     nold2=nold1
                     nold1=t
                     loop
                  ok
                  return t
        end
        return t
