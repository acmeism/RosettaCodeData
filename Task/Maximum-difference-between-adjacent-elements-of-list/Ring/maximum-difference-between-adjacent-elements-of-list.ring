see "working..." + nl
strList = "[1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3]"
see "Maximum difference between adjacent elements of list is:" + nl + nl
see "Input list = " + strList + nl + nl
see "Output:" + nl
sList = [1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3]
sortList = []

for n = 1 to len(sList)-1
    diff = fabs(sList[n]-sList[n+1])
    oldDiff = diff
    first = sList[n]
    second = sList[n+1]
    add(sortList,[oldDiff,first,second])
next

sortList = sort(sortlist,1)
sortList = reverse(sortlist)
flag = 1

for n=1 to len(sortList)-1
    oldDiff1 = sortlist[n][1]
    oldDiff2 = sortlist[n+1][1]
    first1 = sortlist[n][2]
    second1 = sortlist[n][3]
    first2 = sortlist[n+1][2]
    second2 = sortlist[n+1][3]
    if n = 1 and oldDiff1 != oldDiff2
       see "" + first1 + "," + second1 + " ==> " + oldDiff1 + nl
    ok
    if oldDiff1 = oldDiff2
       if flag = 1
          flag = 0
          see "" + first1 + "," + second1 + " ==> " + oldDiff1 + nl
          see "" + first2 + "," + second2 + " ==> " + oldDiff2 + nl
       else
          see "" + first2 + "," + second2 + " ==> " + oldDiff2 + nl
       ok
    else
       exit
    ok
next

see "done..." + nl
