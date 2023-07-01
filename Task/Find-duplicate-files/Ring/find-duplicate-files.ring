# Project : Find duplicate files

d = "/Windows/System32"
chdir(d)
dir = dir(d)
dirlist = []
for n = 1 to len(dir)
     if dir[n][2] = 0
        str = read(dir[n][1])
        lenstr = len(str)
        add(dirlist,[lenstr,dir[n][1]])
     ok
next
see "Directory : " + d + nl
see "--------------------------------------------" + nl
dirlist = sortfirst(dirlist)
line = 0
for n = 1 to len(dirlist)-1
     if dirlist[n][1] = dirlist[n+1][1]
        see "" + dirlist[n][1] + " " + dirlist[n][2] + nl
        see "" + dirlist[n+1][1] + " " + dirlist[n+1][2] + nl
        if n < len(dirlist)-2 and dirlist[n+1][1] != dirlist[n+2][1]
           line = 1
        ok
     else
        line = 0
     ok
     if line = 1
        see "--------------------------------------------" + nl
     ok
next

func sortfirst(alist)
        for n = 1 to len(alist) - 1
             for m = n + 1 to len(alist)
                  if alist[m][1] < alist[n][1]
                     swap(alist,m,n)
                  ok
                  if alist[m][1] = alist[n][1] and strcmp(alist[m][2],alist[n][2]) < 0
                     swap(alist,m,n)
                  ok
             next
        next
        return alist
