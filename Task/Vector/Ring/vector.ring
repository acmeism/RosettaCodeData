# Project : Vector

decimals(1)
vect1 = [5, 7]
vect2 = [2, 3]
vect3 = list(len(vect1))

for n = 1 to len(vect1)
    vect3[n] = vect1[n] + vect2[n]
next
showarray(vect3)

for n = 1 to len(vect1)
    vect3[n] = vect1[n] - vect2[n]
next
showarray(vect3)

for n = 1 to len(vect1)
    vect3[n] = vect1[n] * vect2[n]
next
showarray(vect3)

for n = 1 to len(vect1)
    vect3[n] = vect1[n] / 2
next
showarray(vect3)

func showarray(vect3)
     see "["
     svect = ""
     for n = 1 to len(vect3)
         svect = svect + vect3[n] + ", "
     next
     svect = left(svect, len(svect) - 2)
     see svect
     see "]" + nl
