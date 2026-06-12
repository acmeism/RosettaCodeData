# Project : Reverse the gender of a string

revGender = list(4)
word = ["She", "she", "Her", "her", "hers", "He", "he", "His", "his", "him"]
repl = ["He", "he", "His", "his" ,"his", "She", "she", "Her", "her", "her"]

revGender[1] = "She was a soul stripper. She took his heart!"
revGender[2] = "He was a soul stripper. He took her heart!"
revGender[3] = "She wants what's hers, he wants her and she wants him!"
revGender[4] = "Her dog belongs to him but his dog is hers!"

for p=1 to 4
    gstr = ""
    see revGender[p] + " ->" + nl
    gend = repl(revGender[p])
    for nr=1 to len(gend)
        if nr = len(gend)
           gstr = gstr + gend[nr]
        else
           gstr = gstr + gend[nr] + " "
        ok
    next
    gstr = trim(gstr)
    gstr = left(gstr, len(gstr) - 2)
    if right(gstr, 1) != "!"
       gstr = gstr + "!"
    ok
    see gstr + nl + nl
next

func repl(cStr)
     cStr = words(cStr) + nl
     for n=1 to len(cStr)
         flag = 0
         for m=1 to len(word)
             if right(cStr[n],1) = ","
                cStr[n] = left(cStr[n], len(cStr[n]) - 1)
                flag = 1
             ok
             if right(cStr[n],1) = "!"
                cStr[n] = left(cStr[n], len(cStr[n]) - 1)
                flag = 2
             ok
             if cStr[n] = word[m]
                if flag = 0
                   cStr[n] = repl[m]
                ok
                if flag = 1
                   cStr[n] = repl[m] + ","
                ok
                if flag = 2
                   cStr[n] = repl[m] + "!"
                ok
                exit
             ok
         next
        next
        return cStr


func words(cStr2)
     aList = str2list(cStr2)
     for x in aList
         x2 = substr(x," ",nl)
         alist2 = str2list(x2)
     next
     return alist2
