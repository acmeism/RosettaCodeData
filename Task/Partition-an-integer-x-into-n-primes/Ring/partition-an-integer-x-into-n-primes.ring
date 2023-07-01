# Project : Partition an integer X into N primes

load "stdlib.ring"
nr = 0
num = 0
list = list(100000)
items = newlist(pow(2,len(list))-1,100000)
while true
          nr = nr + 1
          if isprime(nr)
             num = num + 1
             list[num] = nr
          ok
          if num = 100000
              exit
          ok
end

powerset(list,100000)
showarray(items,100000)
see nl

func showarray(items,ind)
        for p = 1 to 20
              if (p > 17 and p < 21) or p = 99809 or p = 2017  or p = 22699  or p = 40355
                  for n = 1 to len(items)
                       flag = 0
                       for m = 1 to ind
                             if items[n][m] = 0
                                exit
                             ok
                             flag = flag + items[n][m]
                       next
                       if flag = p
                          str = ""
                          for x = 1 to len(items[n])
                               if items[n][x] != 0
                                  str = str + items[n][x] + " "
                               ok
                          next
                          str = left(str, len(str) - 1)
                          str = str + "]"
                          if substr(str, " ") > 0
                             see "" + p + " = ["
                             see str + nl
                             exit
                          else
                             str = ""
                          ok
                       ok
                  next
              ok
        next

func powerset(list,ind)
        num = 0
        num2 = 0
        items = newlist(pow(2,len(list))-1,ind)
        for i = 2 to (2 << len(list)) - 1 step 2
             num2 = 0
             num = num + 1
             for j = 1 to len(list)
                  if i & (1 << j)
                      num2 = num2 + 1
                      if list[j] != 0
                        items[num][num2] = list[j]
                     ok
                  ok
             next
        next
        return items
