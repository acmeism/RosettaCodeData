aList = "She was a soul stripper. She took my heart!"
bList = "aei"
see aList + nl
see stripChars(aList,bList)

func stripChars cList, dList
     for n = 1 to len(dList)
         cList = substr(cList,dList[n],"") + nl
     next
     return cList
