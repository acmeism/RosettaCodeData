load "stdlib.ring"

see "work..." + nl
txt = read("words.txt")
txt = str2list(txt)
for n = 1 to len(txt)
    txtStr = string(txt[n])
    txtRev = reverse(txtStr)
    ind = find(txt,txtRev)
    if ind > 0 and len(txtRev) > 6
       see txtStr + " " + txtRev + nl
    ok
next
see "done..." + nl

func reverse(rev)
     re = ""
     revstr = string(rev)
     for n = len(revstr) to 1 step -1
         re = re + revstr[n]
         re = string(re)
     next
     return re
