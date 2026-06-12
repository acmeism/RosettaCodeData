see "working..." + nl

List = [6,81,243,14,25,49,123,69,11]
n = 0

while true
      n++
      List = sort(List)
      first = List[1]
      second = List[2]
      ind1 = find(List,first)
      ind2 = find(List,second)
      if ind1 < ind2
         del(List,ind2)
         del(List,ind1)
      else
         del(List,ind1)
         del(List,ind2)
      ok
      sum = first + second
      add(List,sum)
      if len(List) = 1
         exit
      ok
      if n = 1
         see nl + "List = "
         showArray(List)
         see nl
      ok
      showList(first,second,sum,List)
end

see "Last item is: " +List[1] + nl
see "done..." + nl

func showList(first,second,sum,List)
     see "two smallest is = " + first + " + " + second + " = " + sum + nl
     see "List = "
     showArray(List)

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt + nl
