# Project : Vampire number

for p = 10 to 127000
     vampire(p)
next

func vampire(listnum)
        sum = 0
        flag = 1
        list = list(len(string(listnum)))
        total = newlist(len(list),2)
       for n = 1 to len(string(listnum))
            liststr = string(listnum)
            list[n] = liststr[n]
       next

       for perm = 1 to fact(len(list))
            numstr = substr(list2str(list), nl, "")
            num1 = number(left(numstr,len(numstr)/2))
            num2 = number(right(numstr,len(numstr)/2))
            if (listnum = num1 * num2)
                for n = 1 to len(total)
                     if (num1 = total[n][2] and num2 = total[n][1]) or
                         (num1 = total[n][1] and num2 = total[n][2])
                         flag = 0
                     ok
               next
               if flag = 1
                   sum = sum + 1
                   total[sum][1] = num1
                   total[sum][2] = num2
                   see "" + listnum + ": [" + num1 + "," + num2 + "]" + nl
                ok
             ok
            nextPermutation(list)
       next

func nextPermutation(a)
     elementcount = len(a)
     if elementcount < 1 then return ok
     pos = elementcount-1
     while a[pos] >= a[pos+1]
           pos -= 1
           if pos <= 0 permutationReverse(a, 1, elementcount)
              return ok
     end
     last = elementcount
     while a[last] <= a[pos]
           last -= 1
     end
     temp = a[pos]
     a[pos] = a[last]
     a[last] = temp
     permutationReverse(a, pos+1, elementcount)

 func permutationReverse a, first, last
      while first < last
            temp = a[first]
            a[first] = a[last]
            a[last] = temp
            first += 1
            last -= 1
      end

func fact(nr)
        if nr = 1
           return 1
        else
           return nr * fact(nr-1)
        ok

func newlist(x,y)
        if isstring(x) x=0+x ok
        if isstring(y) y=0+y ok
        alist = list(x)
        for t in alist
              t = list(y)
        next
        return alist
