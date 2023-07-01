# Project: Rosetta Code/Find unimplemented tasks

load "stdlib.ring"
ros= download("http://rosettacode.org/wiki/Category:Programming_Tasks")
lang = "Ring"
pos = 1
num = 0
totalros = 0
rosname = ""
rostitle = ""
see "Tasks not implemented in " + lang + " language:" + nl
for n = 1 to len(ros)
        nr = searchstring(ros,'<li><a href="/wiki/',pos)
        if nr = 0
           exit
        else
           pos = nr + 1
        ok
        nr = searchname(nr)
        nr = searchtitle(nr)
next
see nl
see "Total: " + totalros + " examples." + nl

func searchstring(str,substr,n)
       newstr=right(str,len(str)-n+1)
       nr = substr(newstr, substr)
       if nr = 0
          return 0
       else
          return n + nr -1
       ok

func searchname(sn)
       nr2 = searchstring(ros,'">',sn)
       nr3 = searchstring(ros,"</a></li>",sn)
       rosname = substr(ros,nr2+2,nr3-nr2-2)
       return sn

func searchtitle(sn)
        st = searchstring(ros,"title=",sn)
        rostitle = substr(ros,sn+19,st-sn-21)
        rostitle = "rosettacode.org/wiki/" + rostitle
        rostitle = download(rostitle)
        s = substr(rostitle,lang)
        if s = 0
           num = num + 1
           totalros = totalros + 1
           see "" + num + ". " + rosname + nl
        ok
        return sn

func count(cstring,dstring)
       sum = 0
       while substr(cstring,dstring) > 0
               sum = sum + 1
              cstring = substr(cstring,substr(cstring,dstring)+len(string(sum)))
       end
       return sum
