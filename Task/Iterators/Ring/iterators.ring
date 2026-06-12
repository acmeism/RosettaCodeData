list = [["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],
          ["Red","Orange","Yellow","Green","Blue","Purple"]]
ind = [1,4,5]
revInd = reverse(ind)

see "working..." +nl
see "All elements:" + nl

for n = 1 to len(list)
     for m = 1 to len(list[n])
          see list[n][m] + " "
     next
     see nl
next

see nl + "First, fourth, and fifth elements:" + nl

for n = 1 to len(list)
     for m = 1 to len(ind)
          see list[n][m] + " "
     next
     see nl
next

see nl +"Reverse first, fourth, and fifth elements:" + nl

for n = 1 to len(list)
     for m = 1 to len(revInd)
          see list[n][m] + " "
     next
     see nl
next

see "done..." +nl
