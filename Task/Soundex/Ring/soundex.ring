# Project: Soundex

name = ["Ashcraf", "Ashcroft", "Gauss", "Ghosh", "Hilbert", "Heilbronn", "Lee", "Lloyd",
              "Moses", "Pfister", "Robert", "Rupert", "Rubin","Tymczak", "Soundex", "Example"]
for i = 1 to 16
     sp = 10 - len(name[i])
     see '"' + name[i] + '"' + copy(" ", sp) + " " + soundex(name[i]) + nl
next

func soundex(name2)
name2 = upper(name2)
n = "01230129022455012623019202"
s = left(name2,1)
p = number(substr(n, ascii(s) - 64, 1))
for i = 2 to len(name2)
     n2 = number(substr(n, ascii(name2[i]) - 64, 1))
     if n2 > 0 and n2 != 9 and n2 != p s = s + string(n2) ok
     if n2 != 9 p = n2 ok
next
return left(s + "000", 4)
