cStr = read("C:\Ring\bin\filename.txt")
aList = str2list(cStr)
see aList + nl
lineStart = 3
lineCount = 5
num = -1
for n = lineStart to lineStart+lineCount-1
    num += 1
    del(aList,n-num)
next
cStr = list2str(aList)
see cStr + nl
write("C:\Ring\bin\filename.txt",cStr)
