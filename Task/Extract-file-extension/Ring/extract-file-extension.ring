# Project : Extract file extension

test = ["http://example.com/download.tar.gz",
           "CharacterModel.3DS",
           ".desktop",
           "document",
           "document.txt_backup",
           "/etc/pam.d/login"]

for n = 1 to len(test)
    flag = 1
    revtest = revstr(test[n])
    nr = substr(revtest, ".")
    if nr > 0
       revtest2 = left(revtest, nr)
       for m = 1 to len(revtest2)
           if (ascii(revtest2[m]) > 64 and ascii(revtest2[m]) < 91) or
              (ascii(revtest2[m]) > 96 and ascii(revtest2[m]) < 123) or
               isdigit(revtest2[m]) or revtest2[m] = "."
           else
               flag = 0
           ok
       next
    else
       flag = 0
    ok
    if flag = 1
       revtest3 = revstr(revtest2)
       see test[n] + " -> " + revtest3 + nl
    else
       see test[n] + " -> (none)" + nl
    ok
next

func revstr(cStr)
       cStr2 = ""
       for x = len(cStr) to 1 step -1
           cStr2 += cStr[x]
       next
       return cStr2
