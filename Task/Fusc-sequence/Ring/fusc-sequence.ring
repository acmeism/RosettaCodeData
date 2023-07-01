# Project: Fusc sequence

max = 60
fusc = list(36000)
fusc[1] = 1
see "working..." + nl
see "wait for done..." + nl
see "The first 61 fusc numbers are:" + nl
fuscseq(max)
see "0"
for m = 1 to max
    see " " + fusc[m]
next

see nl
see "The fusc numbers whose length > any previous fusc number length are:" + nl
see "Index Value" + nl
see " 0     0" + nl
d = 10
for i = 1 to 36000
    if fusc[i] >= d
        see " " + i + "   " + fusc[i] + nl
        if d = 0
           d = 1
        ok
        d = d*10
    ok
next
see "done..." + nl

func fuscseq(max)
     for n = 2 to 36000
         if n%2 = 1
            fusc[n] = fusc[(n-1)/2] + fusc[(n+1)/2]
         but n%2 = 0
             fusc[n] = fusc[n/2]
         ok
     next
