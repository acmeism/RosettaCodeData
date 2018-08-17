# Project : Non-continuous subsequences

load "stdlib.ring"
list = [1,2,3,4]
items = newlist(pow(2,len(list))-1,len(list))
see "For [1, 2, 3, 4] non-continuous subsequences are:" + nl
powerset(list,4)
showarray(items,4)
see nl

list = [1,2,3,4,5]
items = newlist(pow(2,len(list))-1,len(list))
see "For [1, 2, 3, 4, 5] non-continuous subsequences are:" + nl
powerset(list,5)
showarray(items,5)

func showarray(items,ind)
        for n = 1 to len(items)
             flag = 0
             for m = 1 to ind - 1
                  if items[n][m] = 0 or items[n][m+1] = 0
                     exit
                 ok
                 if (items[n][m] + 1) != items[n][m+1]
                     flag = 1
                     exit
                 ok
            next
            if flag = 1
               see "["
               str = ""
               for x = 1 to len(items[n])
                    if items[n][x] != 0
                       str = str + items[n][x] + " "
                    ok
               next
               str = left(str, len(str) - 1)
               see str + "]" + nl
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
