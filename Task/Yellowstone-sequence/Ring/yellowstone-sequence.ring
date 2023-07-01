see "working..." + nl
row = 3
num = 2
numbers = 1:51
first = 2
second = 3
see "Yellowstone numbers are:" + nl
see "1 " + first + " " + second + " "

     for n = 4 to len(numbers)
         flag1 = 1
         flag2 = 1
         if first < numbers[n]
            min = first
         else
            min = numbers[n]
         ok
         for m = 2 to min
             if first%m = 0 and numbers[n]%m = 0
                flag1 = 0
                exit
             ok
         next
         if second < numbers[n]
            min = second
         else
            min = numbers[n]
         ok
         for m = 2 to min
             if second%m = 0 and numbers[n]%m = 0
                flag2 = 0
                exit
             ok
         next
         if flag1 = 0 and flag2 = 1
            see "" + numbers[n] + " "
            first = second
            second = numbers[n]
            del(numbers,n)
            row = row+1
            if row%10 = 0
               see nl
            ok
            num = num + 1
            if num = 29
               exit
            ok
            n = 3
         ok
    next

    see "Found " + row + " Yellowstone numbers" + nl
    see "done..." + nl
