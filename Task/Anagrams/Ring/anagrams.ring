# Project : Anagrams
# Date    : 2017/11/28
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
fn1 = "unixdict.txt"

fp = fopen(fn1,"r")
str = fread(fp, getFileSize(fp))
fclose(fp)
strlist = str2list(str)
anagram = newlist(len(strlist), 5)
anag = list(len(strlist))
result = list(len(strlist))
for x = 1 to len(result)
     result[x] = 0
next
for x = 1 to len(anag)
     anag[x] = 0
next
for x = 1 to len(anagram)
    for y = 1 to 5
         anagram[x][y] = 0
    next
next

for n = 1 to len(strlist)
     for m = 1 to len(strlist)
          sum = 0
          if len(strlist[n]) = 4 and len(strlist[m]) = 4 and n != m
             for p = 1 to len(strlist[m])
                  temp1 = count(strlist[n], strlist[m][p])
                  temp2 = count(strlist[m], strlist[m][p])
                  if temp1 = temp2
                     sum = sum + 1
                  ok
             next
             if sum = 4
                anag[n] = anag[n] + 1
                if anag[n] < 6 and result[n] = 0 and result[m] = 0
                   anagram[n][anag[n]] = strlist[m]
                   result[m] = 1
                ok
             ok
          ok
    next
    if anag[n] > 0
       result[n] = 1
    ok
next

for n = 1 to len(anagram)
     flag = 0
     for m = 1 to 5
         if anagram[n][m] != 0
            if m = 1
               see strlist[n] +  " "
               flag = 1
            ok
            see anagram[n][m] + " "
         ok
     next
     if flag = 1
        see nl
     ok
next

func getFileSize fp
       c_filestart = 0
       c_fileend = 2
       fseek(fp,0,c_fileend)
       nfilesize = ftell(fp)
       fseek(fp,0,c_filestart)
       return nfilesize

func count(astring,bstring)
       cnt = 0
       while substr(astring,bstring) > 0
               cnt = cnt + 1
               astring = substr(astring,substr(astring,bstring)+len(string(sum)))
       end
       return cnt
