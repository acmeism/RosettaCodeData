# Project: Create an HTML table

load "stdlib.ring"

str = ""
ncols = 3
nrows = 4

str = str + "<html><head></head><body>" + windowsnl()
str = str + "<table border=1 cellpadding=10 cellspacing=0>" + windowsnl()

for row = 0 to nrows
     if row = 0
        str = str + "<tr><th></th>"
    else
        str = str + "<tr><th>" + row + "</th>"
    ok
    for col = 1 to ncols
         if row = 0
            str = str + "<th>" + char(87 + col) + "</th>"
         else
            str = str + "<td align=" + '"right"' + ">" + random(9999) + "</td>"
         ok
    next
    str = str + windowsnl() + "</tr>" +windowsnl()
next

str = str + "</table>" + windowsnl()
str = str + "</body></html>" + windowsnl()

remove("temp.htm")
write("temp.htm",str)
see str + nl
systemcmd("temp.htm")
