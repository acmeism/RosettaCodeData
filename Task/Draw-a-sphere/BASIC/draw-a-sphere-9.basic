SCREEN 13 ' enter high-color graphic mode

' sets palette colors B/N
FOR i = 0 TO 255
 PALETTE 255 - i, INT(i / 4) + INT(i / 4) * 256 + INT(i / 4) * 65536
NEXT i
PALETTE 0, 0

' draw the sphere
FOR i = 255 TO 0 STEP -1
 x = 50 + i / 3
 y = 99
 CIRCLE (x, y), i / 3, i
 PAINT (x, y), i
NEXT i

' wait until keypress
DO: LOOP WHILE INKEY$ = ""
END
