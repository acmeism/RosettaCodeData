# print some Zeckendorf number representations                             #

# We handle 32-bit numbers, the maximum fibonacci number that can fit in a #
# 32 bit number is F(45)                                                   #

# build a table of 32-bit fibonacci numbers                                #
[ 45 ]INT fibonacci;
fibonacci[ 1 ] := 1;
fibonacci[ 2 ] := 2;
FOR i FROM 3 TO UPB fibonacci DO fibonacci[ i ] := fibonacci[ i - 1 ] + fibonacci[ i - 2 ] OD;

# returns the Zeckendorf representation of n or "?" if one cannot be found #
PROC to zeckendorf = ( INT n )STRING:
     IF n = 0 THEN
        "0"
     ELSE
        STRING result := "";
        INT    f pos  := UPB fibonacci;
        INT    rest   := ABS n;
        # find the first non-zero Zeckendorf digit                        #
        WHILE f pos > LWB fibonacci AND rest < fibonacci[ f pos ] DO
            f pos -:= 1
        OD;
        # if we found a digit, build the representation                   #
        IF f pos >= LWB fibonacci THEN
            # have a digit                                                #
            BOOL skip digit := FALSE;
            WHILE f pos >= LWB fibonacci DO
                IF   rest <= 0 THEN
                    result    +:= "0"
                ELIF skip digit THEN
                    # we used the previous digit                          #
                    skip digit := FALSE;
                    result    +:= "0"
                ELIF rest < fibonacci[ f pos ] THEN
                    # can't use the digit at f pos                        #
                    skip digit := FALSE;
                    result    +:= "0"
                ELSE
                    # can use this digit                                  #
                    skip digit := TRUE;
                    result    +:= "1";
                    rest      -:= fibonacci[ f pos ]
                FI;
                f pos -:= 1
            OD
        FI;
        IF rest = 0 THEN
            # found a representation                                      #
            result
        ELSE
            # can't find a representation                                 #
            "?"
        FI
     FI; # to zeckendorf #

FOR i FROM 0 TO 20 DO
    print( ( whole( i, -3 ), " ", to zeckendorf( i ), newline ) )
OD
