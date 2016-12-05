aList = 'apples, pears # and bananas'
see aList + nl
see stripComment(aList) + nl
aList = 'apples, pears // and bananas'
see aList + nl
see stripComment(aList) + nl

func stripComment bList
     nr = substr(bList,"#")
     if nr > 0 cList = substr(bList,1,nr-1) ok
     nr = substr(bList,"//")
     if nr > 0 cList = substr(bList,1,nr-1) ok
     return cList
