# Project : Short-circuit evaluation
# Date    : 2018/01/23
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

for k = 1 to 2
      word = ["AND","OR"]
      see "========= " + word[k] + " ==============" + nl
      for i = 0 to 1
           for j = 0 to 1
                see "a(" + i + ") " + word[k] +" b(" + j + ")" + nl
                res =a(i)
                if word[k] = "AND" and res != 0
                   res = b(j)
                ok
                if word[k] = "OR"  and res = 0
                   res = b(j)
                ok
           next
      next
next

func a(t)
        see char(9) + "calls func a" + nl
        a = t
        return a

func b(t)
        see char(9) + "calls func b" + nl
        b = t
        return b
