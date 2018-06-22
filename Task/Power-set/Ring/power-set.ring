# Project : Power set
# Date    : 2018/01/13
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

list = ["1", "2", "3", "4"]
see powerset(list)

func powerset(list)
        s = "{"
        for i = 1 to (2 << len(list)) - 1 step 2
             s = s + "{"
             for j = 1 to len(list)
                  if i & (1 << j)
                     s = s + list[j] + ","
                  ok
             next
             if right(s,1) = ","
                s = left(s,len(s)-1)
             ok
             s = s + "},"
        next
        return left(s,len(s)-1) + "}"
