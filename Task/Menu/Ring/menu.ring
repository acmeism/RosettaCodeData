aList = ["fee fie", "huff and puff", "mirror mirror", "tick tock"]
selected = menu(aList, "please make a selection: ")
see "" + selected + nl

func menu aList, prompt
     ndex = 1
     while index>0 and index<=len(aList)
           for index = 1 to len(aList)
               if aList[index]!="" see "" + index + " : " + aList[index] + " " ok
           next
           see nl
           see prompt
           give select
           index = number(select)
           see "" + aList[index] + nl
           if select!=string(index) index = -1 ok
           if index>=0 if index<=len(aList) if aList[index]="" index = -1 ok ok ok
     end
     return aList[index]
