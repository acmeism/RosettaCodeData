PR read "aArray.a68" PR

# number of additions to attempt before deciding the number is Lychrel #
INT max additions = 500;

# buffer to hold number during testing                                 #
# addition of two equal sized numbers can produce a number of at most  #
# one additional digit, so for 500 additions of numbers up to 10 000   #
# we need a bit over 500 digits...                                     #
[ 512 ]CHAR number;
FOR c TO UPB number DO number[ c ] := "0" OD;
# count of used digits in number                                       #
INT digits := 0;

# sets the number buffer to the specified positive value               #
PROC set number = ( INT value )VOID:
    BEGIN
        digits := 0;
        INT v  := ABS value;
        WHILE digits +:= 1;
              number[ digits ] := REPR ( ABS "0" + v MOD 10 );
              v OVERAB 10;
              v > 0
        DO SKIP OD
     END # set number # ;

# adds the reverse of number to itself                                 #
PROC add reverse = VOID:
     BEGIN
        [ digits + 1 ]CHAR result;
        INT carry := 0;
        INT r pos := digits;
        FOR d pos TO digits DO
            INT sum = ( ( ABS number[ d pos ] + ABS number[ r pos ] + carry )
                      - ( 2 * ABS "0" )
                      );
            IF sum < 10 THEN
                # no carry required                                    #
                result[ d pos ] := REPR( sum + ABS "0" );
                carry           := 0
            ELSE
                # need to carry                                        #
                result[ d pos ] := REPR ( ( sum - 10 ) + ABS "0" );
                carry           := 1
            FI;
            r pos -:= 1
        OD;
        IF carry /= 0 THEN
            # need another digit                                       #
            digits +:= 1;
            result[ digits ] := REPR ( ABS "0" + carry )
        FI;
        number[ : digits ] := result[ : digits ]
     END # add reverse # ;

# returns TRUE if number is a palindrome, FALSE otherwise              #
PROC is palindromic = BOOL:
     BEGIN
        BOOL result := TRUE;
        INT d pos := 1;
        INT r pos := digits;
        WHILE IF   d pos >= r pos
              THEN FALSE
              ELSE result := ( number[ d pos ] = number[ r pos ] )
              FI
        DO
            d pos +:= 1;
            r pos -:= 1
        OD;
        result
     END # is palindromic # ;

# associative array of numbers that are not palindromic after 500      #
# iterations                                                           #
REF AARRAY related := INIT HEAP AARRAY;

# adds the elements of the specified path to the related numbers       #
PROC add related numbers = ( REF AARRAY path )VOID:
     BEGIN
        REF AAELEMENT r := FIRST path;
        WHILE r ISNT nil element DO
            related // key OF r := "Y";
            r := NEXT path
        OD
     END # add related numbers # ;

# Lychrel number results                                               #
# lychrel[n] is:                                                       #
#    not lychrel      if n becomes palidromic before 500 additions     #
#    lychrel seed     if n is a seed lychrel number                    #
#    lychrel related  if n is a related lychrel number                 #
#    untested         if n hasn't been tested yet                      #
INT not lychrel      = 0;
INT lychrel seed     = 1;
INT lychrel related  = 2;
INT untested         = 3;
INT max number = 10 000;
[ max number ]INT lychrel;
FOR n TO UPB lychrel DO lychrel[ n ] := untested OD;
[ UPB lychrel ]BOOL palindromic;
FOR n TO UPB palindromic DO palindromic[ n ] := FALSE OD;
INT seed count       := 0;
INT related count    := 0;
INT palindrome count := 0;

# set the lychrel array to the values listed above                     #
FOR n TO UPB lychrel DO
    # classify this number                                             #
    set number( n );
    palindromic[ n ] := is palindromic;
    add reverse;
    REF AARRAY path  := INIT HEAP AARRAY;
    BOOL continue searching := TRUE;
    TO max additions WHILE continue searching :=
                     IF related CONTAINSKEY number[ : digits ] THEN
                         # this number is already known to be lychrel  #
                         lychrel[ n ] := lychrel related;
                         add related numbers( path );
                         related count +:= 1;
                         FALSE
                     ELIF is palindromic THEN
                         # have reached a palindrome                   #
                         lychrel[ n ] := not lychrel;
                         FALSE
                     ELSE
                         # not palindromic - try another iteration     #
                         path // number[ : digits ] := "Y";
                         add reverse;
                         TRUE
                     FI
    DO SKIP OD;
    IF continue searching THEN
        # we have a lychrel seed                                       #
        add related numbers( path );
        lychrel[ n ] := lychrel seed;
        seed count  +:= 1
    FI;
    IF palindromic[ n ] AND ( lychrel[ n ] = lychrel seed OR lychrel[ n ] = lychrel related ) THEN
        # have a palindromic related or seed lychrel number            #
        palindrome count +:= 1
    FI
OD;

# print the lychrel numbers up to max number                           #
print( ( "There are "
       , whole( seed count,    0 ), " seed Lychrel numbers and "
       , whole( related count, 0 ), " related Lychrel numbers up to "
       , whole( UPB lychrel,   0 )
       , newline
       )
     );
# shpw the seeds                                                       #
print( ( "Seed Lychrel numbers up to ", whole( UPB lychrel, 0 ), ":" ) );
FOR n TO UPB lychrel DO IF lychrel[ n ] = lychrel seed THEN print( ( " ", whole( n, 0 ) ) ) FI OD;
print( ( newline ) );
# show the Lychrel numbers that are palindromic                        #
print( ( "There are "
       , whole( palindrome count, 0 )
       , " palindromic Lychrel numbers up to "
       , whole( UPB lychrel, 0 )
       , ":"
       )
     );
FOR n TO UPB lychrel DO
    IF ( lychrel[ n ] = lychrel seed OR lychrel[ n ] = lychrel related ) AND palindromic[ n ] THEN print( ( " ", whole( n, 0 ) ) ) FI
OD;
print( ( newline ) )
