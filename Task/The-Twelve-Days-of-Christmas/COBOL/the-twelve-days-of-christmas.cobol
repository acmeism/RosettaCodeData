       >>SOURCE FREE
PROGRAM-ID. twelve-days-of-christmas.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  gifts-area VALUE "partridge in a pear tree    "
    & "Two turtle doves              "
    & "Three french hens             "
    & "Four calling birds            "
    & "FIVE GOLDEN RINGS             "
    & "Six geese a-laying            "
    & "Seven swans a-swimming        "
    & "Eight maids a-milking         "
    & "Nine ladies dancing           "
    & "Ten lords a-leaping           "
    & "Eleven pipers piping          "
    & "Twelve drummers drumming      ".
    03  gifts                           PIC X(30) OCCURS 12 TIMES
                                        INDEXED BY gift-idx.

01  ordinals-area VALUE "first     second    third     fourth    fifth     "
    & "sixth     seventh   eighth    ninth     tenth     eleventh  twelfth   ".
    03  ordinals                        PIC X(10) OCCURS 12 TIMES.

01  day-num                             PIC 99 COMP.

PROCEDURE DIVISION.
    PERFORM VARYING day-num FROM 1 BY 1 UNTIL day-num > 12
        DISPLAY "On the " FUNCTION TRIM(ordinals (day-num)) " day of Christmas,"
            " my true love gave to me"

        IF day-num = 1
            DISPLAY "A " gifts (1)
        ELSE
            PERFORM VARYING gift-idx FROM day-num BY -1 UNTIL gift-idx = 1
                DISPLAY gifts (gift-idx)
            END-PERFORM
            DISPLAY "And a " gifts (1)
        END-IF

        DISPLAY SPACE
    END-PERFORM
    .
END PROGRAM twelve-days-of-christmas.
