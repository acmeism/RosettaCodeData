FOR bottles FROM 99 BY -1 TO 1 DO
    STRING bottles now = whole(bottles,0) + " bottle" + IF bottles = 1 THEN "" ELSE "s" FI;
    STRING bottles left = IF bottles = 1 THEN "No more" ELSE whole(bottles-1,0) FI
                        + " bottle"
                        + IF bottles = 2 THEN "" ELSE "s" FI;
    print((bottles now," of beer on the wall",newline));
    print((bottles now," of beer",newline));
    print(("Take one down, pass it around",newline));
    print((bottles left," of beer on the wall",newline,newline))
OD
