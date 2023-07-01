# Project : List rooted trees

list = "()"
addstr = []
flag = 0
newstr = []
str = []
np = [1,2,3,4]
for nr = 1 to len(np)
      if nr = 1
         bg1 = "bag"
       else
         bg1 = "bags"
      ok
      see "for " + nr + " " + bg1 + " :" + nl
     permutation(list,nr*2)
     listroot(nr*2)
next
see "ok" + nl

func listroot(pn)
        for n = 1 to len(addstr)
             result(addstr[n],pn)
             if flag = 1
                see "" + addstr[n] + nl
                addstr[n]
             ok
        next

func result(list,pn)
        flag = 0
        newstr = list
        while substr(newstr, "()") != 0
                 if list = "()" or list = "(())"
                    flag = 1
                    exit
                 ok
                 num = substr(newstr, "()")
                 newstr = substr(newstr, "()", "")
                 if left(list,2) = "()" or right(list,2) = "()" or left(list,4) = "(())" or right(list,4) = "(())"
                    flag = 0
                    exit
                 else
                    if len(list) != 2 and len(list) != 4 and newstr = ""
                       flag = 1
                       exit
                    ok
                 ok
        end

func permutation(list,pn)
       addstr = []
       while true
               str = ""
               for n = 1 to pn
                    rnd = random(1) + 1
                    str = str + list[rnd]
               next
               add(addstr,str)
               for m = 1 to len(addstr)
                    for p = m + 1 to len(addstr) - 1
                         if addstr[m] = addstr[p]
                            del(addstr,p)
                         ok
                    next
               next
               if len(addstr) = pow(2,pn)
                  exit
               ok
       end
