load "zerolib.ring"

recaman = Z(0:50)
duplicate = 0
dup = []
recDuplicate = []
recnum = 0

see "working..." + nl
see "the first 15 Recaman's numbers are:" + nl

for n = 1 to len(recaman) - 1
    if n = 1
       recaman[0] = 0
       add(dup,0)
       see "" + recaman[0] + " "
    ok
    recaman[n] = recaman[n-1] - n
    if recaman[n] <= 0
       recaman[n] = recaman[n-1] + n
    ok
    fnrec = find(dup,recaman[n])
    if fnrec > 0
       del(dup,fnrec)
       recaman[n] = recaman[n-1] + n
       add(dup,recaman[n])
    else
       add(dup,recaman[n])
    ok
    recnum = recnum + 1
    if recnum < 15
       see "" + recaman[n] + " "
    ok
    add(recDuplicate,recaman[n])
next
see nl

see "the first duplicated term is a["
for n = len(recDuplicate) to 2 step -1
    for m = n-1 to 1 step -1
        if recDuplicate[n] = recDuplicate[m]
           duplicate = recDuplicate[n]
           dupnr = n
        ok
    next
next

see "" + dupnr + "] = " + duplicate + nl
see "done..." + nl
