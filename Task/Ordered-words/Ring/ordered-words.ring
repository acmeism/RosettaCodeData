fn = "C:\Ring\unixdict.txt"

fp = fopen(fn,"r")
str = fread(fp, getFileSize(fp))
str = substr(str, windowsnl(), nl)
clist = str2list(str)
fclose(fp)
dlist = []

for m = 1 to len(clist)
    flag = 1
    for n = 1 to len(clist[m])-1
        if ascii(clist[m][n+1]) < ascii(clist[m][n])
           flag=0 exit ok
    next
    if flag = 1
       add(dlist, clist[m]) ok
next

nr = 0
for m = 1 to len(dlist)
    if len(dlist[m]) > nr
       nr = len(dlist[m]) ok
next

for n = 1 to len(dlist)
    if len(dlist[n]) = nr
       see dlist[n] + nl ok
next

func getFileSize fp
     c_filestart = 0
     c_fileend = 2
     fseek(fp,0,c_fileend)
     nfilesize = ftell(fp)
     fseek(fp,0,c_filestart)
     return nfilesize
