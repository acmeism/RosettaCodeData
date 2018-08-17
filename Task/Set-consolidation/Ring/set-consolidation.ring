# Project : Set consolidation

load "stdlib.ring"
test = ["AB","AB,CD","AB,CD,DB","HIK,AB,CD,DB,FGH"]
for t in test
     see consolidate(t) + nl
next
func consolidate(s)
	sets = split(s,",")
	n = len(sets)
	for i = 1 to n
	     p = i
             ts = ""
	     for j = i to 1 step -1
		 if ts = ""
		    p = j
		 ok
		 ts = ""
		 for k = 1 to len(sets[p])
                      if j > 1
		         if substring(sets[j-1],substr(sets[p],k,1),1) = 0
			     ts = ts + substr(sets[p],k,1)
		         ok
                      ok
		 next
		 if len(ts) < len(sets[p])
                    if j > 1
		       sets[j-1] = sets[j-1] + ts
		       sets[p] = "-"
		       ts = ""
                    ok
		 else
		    p = i
		 ok
	     next	
	next
	consolidate = s + " = " + substr(list2str(sets),nl,",")
        return consolidate
