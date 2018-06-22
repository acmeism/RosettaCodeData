# Project : Range extraction
# Date    : 2017/11/08
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

int = "0,1,2,4,6,7,8,11,12,14,15,16,17,18,19,20,21,22,23,24,25,27,28,29,30,31,32,33,35,36,37,38,39"
int = str2list(substr(int, ",", nl))
sumint = []
intnew = 1
for n=1 to len(int)
     flag = 0
     nr = 0
     intnew = 0
     for m=n to len(int)-1
         if int[m] = int[m+1] - 1
            intnew = m+1
            flag = 1
            nr = nr + 1
         else
            exit
          ok
     next
     if flag = 1 and nr > 1
        if intnew != 0
           add(sumint, [n,intnew])
           n = m
        ok
     else
        add(sumint, [n,""])
     ok
next
showarray(sumint)

func showarray(vect)
       see "["
       svect = ""
       for n = 1 to len(vect)
           if vect[n][2] != ""
              svect = svect +"" + int[vect[n][1]] + "-" + int[vect[n][2]] + ", "
           else
              svect = svect +"" + int[vect[n][1]] + ", "
           ok
       next
       svect = left(svect, len(svect) - 2)
       see svect
       see "]" + nl
