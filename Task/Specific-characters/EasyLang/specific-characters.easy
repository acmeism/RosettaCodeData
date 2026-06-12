proc addchar c$ &char$[] &cnt[] .
   for i to len char$[] : if char$[i] = c$
      cnt[i] += 1
      return
   .
   char$[] &= c$
   cnt[] &= 1
.
func[] specific s$[] .
   for c$ in strchars strjoin s$[] ""
      addchar c$ all$[] allcnt[]
   .
   for s$ in s$[]
      res[] &= 0
      one$[] = [ ]
      onecnt[] = [ ]
      for c$ in strchars s$
         addchar c$ one$[] onecnt[]
      .
      for i to len onecnt[] : if onecnt[i] = 2
         for j to len all$[] : if one$[i] = all$[j]
            if allcnt[j] = 2 : res[$] += 1
            break 1
         .
      .
   .
   return res[]
.
print specific [ "ahwiueshaiu" "ajxxfioaaf" "ajrdsfroiwr" ]
