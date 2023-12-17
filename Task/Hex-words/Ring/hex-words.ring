Author = "Gál Zsolt (CalmoSoft)"

load "stdlib.ring"
Words = []
HexWords = ["a","b","c","d","e","f"]
cstr = read("unixdict.txt")
Unix = str2list(cstr)
Unix2 = []
for n = 1 to len(Unix)
    uStr = Unix[n]
    for m = 1 to len(uStr)
        flag =1
        ind = find(HexWords,uStr[m])
        if ind = 0
           flag = 0
           exit
        ok
     next
     if flag = 1 and len(Unix[n]) > 3
        add(Words,Unix[n])
        add(Unix2,Unix[n])
     ok
next

Unix1 = newlist(len(Words),2)
for n = 1 to len(Words)
    num = dec(Words[n])
    dr = digRoot(num)
    Unix1[n][1] = dr
    Unix1[n][2] = Words[n]
next

Unix1 = sortFirstSecondStr(Unix1,1)

see "Root" + space(2) + "Word" + space(5) + "Base 10" + nl
see "====" + space(2) + "====" + space(5) + "=======" + nl
for n = 1 to len(Unix1)
    decnr = dec(Unix1[n][2])
    see string(Unix1[n][1]) + space(5) + Unix1[n][2] + space(9-len(Unix1[n][2])) + decnr + nl
next

see nl + "Table length: " + len(Unix1) + nl + nl + nl

see "Root" + space(2) + "Word" + space(5) + "Base 10" + nl
see "====" + space(2) + "====" + space(5) + "=======" + nl

for n = 1 to len(Unix2)
    str = Unix2[n]
    str2 = sortStr(str)
    flag = 0
    for p = 1 to len(str2)-1
        st1 = substr(str2,p,1)
        st2 = substr(str2,p+1,1)
        if dec(st1) < dec(st2)
           flag += 1
        ok
    next
    if flag < 4
       del(Unix2,n)
    ok
next

DecSort = []
for n = 1 to len(Unix2)
    ds = dec(Unix2[n])
    add(DecSort,ds)
next
DecSort = sort(DecSort)
DecSort = reverse(DecSort)

for n = 1 to len(DecSort)
    root = digRoot(DecSort[n])
    word = hex(DecSort[n])
    decnum = DecSort[n]
    see "" + root + space(5) + word + space(9-len(word)) + decnum + nl
next

see nl + "Table length: " + len(DecSort) + nl

func digRoot(num2)
     while true
           strnr = string(num2)
           sum = 0
           for n = 1 to len(strnr)
               sum += number(strnr[n])
           next
           if sum < 10
              exit
           else
              num2 = sum
           ok
     end
return sum

func sortStr(str2)
     for p = 1 to len(str2)
         for q = p+1 to len(str2)
             if strcmp(str2[q],str2[p]) < 0
                temp = str2[p]
                str2[p] = str2[q]
                str2[q] = temp
             ok
         next
     next
     return str2

func sortFirstSecondStr(aList,ind)
     aList = sort(aList,ind)
     if (ind = 1)
        nr = 2
     else
        nr = 1
     ok
     for n=1 to len(alist)-1
	 for m=n+1 to len(aList)
	     if (alist[n][ind] = alist[m][ind]) and
                (strcmp(alist[m][nr],alist[n][nr]) < 0)
		temp = alist[m]
		alist[m] = alist[n]
		alist[n] = temp
             ok
         next
     next
     return aList
