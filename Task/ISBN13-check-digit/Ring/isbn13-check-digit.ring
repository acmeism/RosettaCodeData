load "stdlib.ring"

isbn = ["978-1734314502","978-1734314509", "978-1788399081", "978-1788399083","978-2-74839-908-0","978-2-74839-908-5","978 1 86197 876 9"]

for n = 1 to len(isbn)
    sum = 0
    isbnStr = isbn[n]
    isbnStr = substr(isbnStr,"-","")
    isbnStr = substr(isbnStr," ","")
    for m = 1 to len(isbnStr)
        if m%2 = 0
           num = 3*number(substr(isbnStr,m,1))
           sum = sum + num
        else
           num = number(substr(isbnStr,m,1))
           sum = sum + num
        ok
    next
    if sum%10 = 0
       see "" + isbn[n] + ": true" + nl
    else
       see "" + isbn[n] + ": bad" + nl
    ok
next
