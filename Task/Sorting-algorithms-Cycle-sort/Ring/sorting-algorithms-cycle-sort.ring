# Project : Sorting algorithms/Cycle sort

array = [0, 1, 2, 2, 2, 2, 1, 9, 3, 5, 5, 8, 4, 7, 0, 6]
seearray(array)
writes = cyclesort(array)
see "after sorting with " + writes + " writes :" + nl
seearray(array)
see nl
array2 = [38, 119, 38, 33, 33, 28, 24, 101, 108, 120, 99, 59, 69, 24, 117, 22, 90, 94, 78, 75]
seearray(array2)
writes = cyclesort(array2)
see "after sorting with " + writes  + " writes :" + nl
seearray(array2)

func cyclesort(array)
        length = len(array)
        if length = 0
           return 0
        ok
        writes = 0
        for cyclestart = 1 to len(array) - 1
             item = array[cyclestart]
             position = cyclestart
             for i = cyclestart + 1 to len(array)
                  if array[i] < item
                     position = position +  1
                  ok
             next
             if position = cyclestart
                loop
             ok
             while item = array[position]
                     position = position+ 1
             end
             temp = item
             item = array[position]
             array[position] = temp
             writes = writes + 1
             while position != cyclestart
                     position = cyclestart
                     for i = cyclestart + 1 to len(array)
                          if array[i] < item
                             position = position + 1
                          ok
                     next
                     while item = array[position]
                             position = position + 1
                     end
                     temp = item
                     item = array[position]
                     array[position] = temp
                     writes = writes + 1
             end
        next
        return writes

func seearray(array)
        for i = 1 to len(array)
            see string(array[i]) + " "
        next
        see nl
