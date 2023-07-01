# Project : Amb

set1 = ["the","that","a"]
set2 = ["frog","elephant","thing"]
set3 = ["walked","treaded","grows"]
set4 = ["slowly","quickly"]
text = amb(set1,set2,set3,set4)
if text != ""
   see "Correct sentence would be: " + nl  + text + nl
else
   see "Failed to fine a correct sentence."
ok

func wordsok(string1, string2)
       if substr(string1,len(string1),1) = substr(string2,1,1)
          return true
       ok
       return false

func amb(a,b,c,d)
       for a2 = 1 to len(a)
            for b2 =1 to len(b)
                 for c2 = 1 to len(c)
                      for d2 = 1 to len(d)
                           if wordsok(a[a2],b[b2]) and wordsok(b[b2],c[c2]) and wordsok(c[c2],d[d2])
                              return a[a2]+" "+b[b2]+" "+c[c2]+" "+d[d2]
                           ok
                      next
                 next
            next
       next
       return ""
