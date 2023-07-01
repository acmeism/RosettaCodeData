# Project : Shortest common supersequence

str1 = "a b c b d a b"
str2 = "bdcaba"
str3 = str2list(substr(str1, " ", nl))
for n = 1 to len(str3)
     for m = n to len(str2)-1
          pos = find(str3, str2[m])
          if pos > 0 and str2[m+1] != str3[pos+1]
             insert(str3, pos, str2[m+1])
          ok
     next
next
showarray(str3)

func showarray(vect)
       svect = ""
       for n = 1 to len(vect)
             svect = svect + vect[n]
       next
       see svect
