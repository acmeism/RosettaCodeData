load "stdlib.ring"

see "working..." + nl
see "First 20 Cullen numbers:" + nl

for n = 1 to 20
    num = n*pow(2,n)+1
    see "" + num + " "
next

see nl + nl + "First 20 Woodall numbers:" + nl

for n = 1 to 20
    num = n*pow(2,n)-1
    see "" + num + " "
next

see nl + "done..." + nl
