# Project : Run-length encoding
# Date    : 2017/12/04
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
test = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
num = 0
nr = 0
decode = newlist(7,2)
for n = 1 to len(test) - 1
     if test[n] = test[n+1]
        num = num + 1
     else
        nr = nr + 1
        decode[nr][1] = (num + 1)
        decode[nr][2] = test[n]
        see "" + (num + 1) + test[n]
        num = 0
     ok
next
see "" + (num + 1) + test[n]
see nl
nr = nr + 1
decode[nr][1] = (num + 1)
decode[nr][2] = test[n]
for n = 1 to len(decode)
     dec = copy(decode[n][2], decode[n][1])
     see dec
next
