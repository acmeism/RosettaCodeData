BEGIN # print odd suares between 100 and 1000 #
    # if 2m + 1 and 2m - 1 are consecutive odd numbers, the difference between their squares is 8m #
    INT to next    := 8;
    INT odd square := 1;
    WHILE odd square < 1000 DO
        IF odd square > 99 THEN
            print( ( " ", whole( odd square, 0 ) ) )
        FI;
        odd square +:= to next;
        to next    +:= 8
    OD
END
