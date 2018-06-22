# Project : Range expansion
# Date    : 2017/11/08
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

int = "-6,-3--1,3-5,7-11,14,15,17-20"
int = str2list(substr(int, ",", nl))
newint = []
for n=1 to len(int)
     nrint = substr(int[n], "-")
     nrint2 = substr(int[n], "--")
     if nrint2 > 0
        temp1 = left(int[n], nrint2 -1)
        temp2 = right(int[n], len(int[n]) - nrint2)
        add(newint, [temp1,temp2])
     else
        if len(int[n]) <= 2
           add(newint, [int[n], ""])
        else
           if nrint > 0 and nrint2 = 0
              temp1 = left(int[n], nrint - 1)
              temp2 = right(int[n], len(int[n]) - nrint)
              add(newint, [temp1,temp2])
           ok
        ok
     ok
next
showarray(newint)

func showarray(vect)
       see "["
       svect = ""
       for n = 1 to len(vect)
           if newint[n][2] != ""
              for nr = newint[n][1] to newint[n][2]
                  svect = svect +"" + nr + ", "
              next
           else
              svect = svect +"" + newint[n][1] + ", "
           ok
       next
       svect = left(svect, len(svect) - 2)
       see svect
       see "]" + nl
