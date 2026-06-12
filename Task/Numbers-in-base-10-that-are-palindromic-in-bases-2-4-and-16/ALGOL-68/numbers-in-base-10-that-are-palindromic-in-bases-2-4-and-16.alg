BEGIN # show numbers in decimal that are palindromic in bases 2, 4 and 16 #
    INT max number = 25 000;    # maximum number to consider #
    INT min base   = 2;         # smallest base needed #
    INT max digits = BEGIN      # number of digits max number has in the smallest base #
                         INT d := 1;
                         INT v := max number;
                         WHILE v >= min base DO
                             v OVERAB min base;
                             d PLUSAB 1
                         OD;
                         d
                     END;
    # returns the digits of n in the specified base #
    PRIO DIGITS = 9;
    OP   DIGITS = ( INT n, INT base )[]INT:
         IF   INT v := ABS n;
              v < base
         THEN v # single dogit #
         ELSE   # multiple digits #
            [ 1 : max digits ]INT result;
            INT d pos := UPB result + 1;
            WHILE v > 0 DO
                result[ d pos -:= 1 ] := v MOD base;
                v OVERAB base
            OD;
            result[ d pos : UPB result ]
         FI # DIGITS # ;
    # returns TRUE if the digits in d form a palindrome, FALSE otherwise #
    OP   PALINDROMIC = ( []INT d )BOOL:
         BEGIN
             INT  left := LWB d, right := UPB d;
             BOOL is palindromic := TRUE;
             WHILE left < right AND is palindromic DO
                 is palindromic := d[ left ] = d[ right ];
                 left          +:= 1;
                 right         -:= 1
             OD;
             is palindromic
         END;
    # print the numbers in decimal that are palendromic in bases 2, 4 and 16 #
    # as noted by the REXX sample, even numbers ( other than 0 ) aren't      #
    # applicable as even numbers end in 0 in base 2 so can't be palendromic  #
    print( ( " 0" ) );              # clearly, 0 is palendromic in all bases #
    FOR n BY 2 TO max number DO
        IF PALINDROMIC ( n DIGITS 16 ) THEN
            IF PALINDROMIC ( n DIGITS 4 ) THEN
                IF PALINDROMIC ( n DIGITS 2 ) THEN
                    print( ( " ", whole( n, 0 ) ) )
                FI
            FI
        FI
    OD;
    print( ( newline ) )
END
