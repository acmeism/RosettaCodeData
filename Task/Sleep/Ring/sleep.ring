load "guilib.ring"

for n = 1 to 10
    Sleep(3)
    see "" + n + " "
next
see nl

func Sleep x
     nTime = x * 1000
     oTest = new qTest
     oTest.qsleep(nTime)
