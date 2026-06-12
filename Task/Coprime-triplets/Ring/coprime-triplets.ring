see "working..." + nl
row = 2
numbers = 1:50
first = 1
second = 2
see "Coprime triplets are:" + nl
see "" + first + " " + second + " "

     for n = 3 to len(numbers)
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
         if flag1 = 1 and flag2 = 1
            see "" + numbers[n] + " "
            first = second
            second = numbers[n]
            del(numbers,n)
            row = row+1
            if row%10 = 0
               see nl
            ok
            n = 2
         ok
    next

    see nl + "Found " + row + " coprime triplets" + nl
    see "done..." + nl
