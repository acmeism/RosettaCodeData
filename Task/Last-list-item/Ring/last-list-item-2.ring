see "working..." + nl

List = [6,81,243,14,25,49,123,69,11]
n = 0

while true
      n++
      if n = 1
         see nl + "List = "
         showArray(List)
         see nl
      ok
      first = min(List)
      ind1 = find(List,first)
      del(List,ind1)
      second = min(List)
      ind2 = find(List,second)
      del(List,ind2)
      sum = first + second
      add(List,sum)
      if len(List) = 1
         exit
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
