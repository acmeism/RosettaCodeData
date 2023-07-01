# Project: Rosetta Code/Rank languages by popularity

load "stdlib.ring"
ros= download("http://rosettacode.org/wiki/Category:Programming_Languages")
pos = 1
totalros = 0
rosname = ""
rosnameold = ""
rostitle = ""
roslist = []
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
roslist = sortfirst(roslist)
roslist = reverse(roslist)

see nl
for n = 1 to len(roslist)
     see "rank: " + n + " (" + roslist[n][1] + " entries) " + roslist[n][2] + nl
next

func searchstring(str,substr,n)
       newstr=right(str,len(str)-n+1)
       nr = substr(newstr, substr)
       if nr = 0
          return 0
       else
          return n + nr -1
       ok

func count(cstring,dstring)
       sum = 0
       while substr(cstring,dstring) > 0
               sum = sum + 1
               cstring = substr(cstring,substr(cstring,dstring)+len(string(sum)))
       end
       return sum

func searchname(sn)
       nr2 = searchstring(ros,"/wiki/Category:",sn)
       nr3 = searchstring(ros,"title=",sn)
       nr4 = searchstring(ros,'">',sn)
       nr5 = searchstring(ros,"</a></li>",sn)
       rosname = substr(ros,nr2+15,nr3-nr2-17)
       rosnameold = substr(ros,nr4+2,nr5-nr4-2)
       return sn

func searchtitle(sn)
        rostitle = "rosettacode.org/wiki/Category:" + rosname
        rostitle = download(rostitle)
        nr2 = 0
        roscount = count(rostitle,"The following")
        if roscount > 0
           rp = 1
           for rc = 1 to roscount
                nr2 = searchstring(rostitle,"The following",rp)
                rp = nr2 + 1
           next
        ok
        nr3 = searchstring(rostitle,"pages are in this category",nr2)
        if nr2 > 0 and nr3 > 0
           rosnr = substr(rostitle,nr2+14,nr3-nr2-15)
           rosnr = substr(rosnr,",","")
           add(roslist,[rosnr,rosnameold])
        ok
        return sn

func sortfirst(alist)
        for n = 1 to len(alist) - 1
             for m = n + 1 to len(alist)
                  if alist[m][1] < alist[n][1]
                     swap(alist,m,n)
                  ok
                  if alist[m][1] = alist[n][1] and strcmp(alist[m][2],alist[n][2]) > 0
                     swap(alist,m,n)
                  ok
             next
        next
        return alist
