# Project : Hash from two arrays

list1="one two three"
list2="1 2 3"
a = str2list(substr(list1," ",nl))
b = str2list(substr(list2," ",nl))
c = list(len(a))
for i=1 to len(b)
     temp = number(b[i])
     c[temp] = a[i]
next
for i = 1 to len(c)
     see c[i] + " " + i + nl
next
