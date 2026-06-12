see "working..." + nl
row = 0
Coprimes = [[21,15],[17,23],[36,12],[18,29],[60,15]]
input = "input: [21,15],[17,23],[36,12],[18,29],[60,15]"
see input + nl
see "Coprimes are:" + nl

lncpr = len(Coprimes)
for n = 1 to lncpr
    flag = 1
    if Coprimes[n][1] < Coprimes[n][2]
       min = Coprimes[n][1]
    else
       min = Coprimes[n][2]
    ok
    for m = 2 to min
        if Coprimes[n][1]%m = 0 and Coprimes[n][2]%m = 0
           flag = 0
           exit
        ok
    next
    if flag = 1
       row = row + 1
       see "" + Coprimes[n][1] + " " + Coprimes[n][2] + nl
    ok
next

see "Found " + row + " coprimes" + nl
see "done..." + nl
