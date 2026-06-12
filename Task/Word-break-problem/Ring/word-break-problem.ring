# Project : Word break problem

load "stdlib.ring"
list = ["a", "bc", "abc", "cd", "b"]
inslist = list
for n = 1 to len(inslist) - 1
      for m = len(inslist) to 1 step -1
            insert(list,0,inslist[m])
      next
next
strings = ["abcd", "abbc", "abcbcd", "acdbc", "abcdd"]
ind = len(list)
items = newlist(pow(2,len(list))-1,ind)
powerset(list,ind)

for p = 1 to len(strings)
      showarray(items,strings[p])
next

func powerset(list,ind)
        num = 0
        num2 = 0
        items = newlist(pow(2,len(list))-1,2*ind)
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

func showarray(items,par)
        ready = []
        for n = 1 to len(items)
              for m = n + 1 to len(items) - 1
                    flag = 0
                    str = ""
                    for x = 1 to len(items[n])
                         if items[n][x] != 0
                            str = str + items[n][x] + " "
                         ok
                    next
                    str = left(str, len(str) - 1)
                    strsave = str
                    str = substr(str, " ", "")
                    if str = par
                       pos = find(ready,strsave)
                       if pos = 0
                          add(ready,strsave)
                          flag = 1
                          see par + " = " + strsave + nl
                      ok
                      if flag != 1
                         del(items,m)
                      ok
                   ok
              next
        next
