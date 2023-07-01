# Project : Eertree

str = "eertree"
pal = []
for n=1 to len(str)
    for m=1 to len(str)
        strrev = ""
        strpal = substr(str, n, m)
        if strpal != ""
           for p=len(strpal) to 1 step -1
               strrev = strrev + strpal[p]
           next
           if strpal = strrev
              add(pal, strpal)
           ok
        ok
    next
next
sortpal = sort(pal)
for n=len(sortpal) to 2 step -1
    if sortpal[n] = sortpal[n-1]
       del(sortpal, n)
    ok
next
see sortpal + nl
