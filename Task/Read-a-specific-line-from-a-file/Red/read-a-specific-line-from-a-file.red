>> x: pick read/lines %file.txt 7

case [
    x = none  [print "File has less than seven lines"]
    (length? x) = 0 [print "Line 7 is empty"]
    (length? x) > 0 [print append "Line seven =  " x]
]
