aList = [7,6,5,9,8,4,3,1,2,0]
see sortList(aList)

func sortList list
     count = len(list) + 1
     last = count - 1

     for i = 1 to last
          minCandidate = i
          j = i + 1
          while j < count
	        if list[j] < list[minCandidate] minCandidate = j ok
	        j = j + 1
          end
          temp = list[i]
          list[i] = list[minCandidate]
          list[minCandidate] = temp
      next
      return list
