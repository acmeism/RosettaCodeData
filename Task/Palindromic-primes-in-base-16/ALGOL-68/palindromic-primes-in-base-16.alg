BEGIN  # find primes that are palendromic in base 16 #
    # sieve the primes to 499 #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 499;
    # returns an array of the digits of n in the specified base #
    PRIO DIGITS = 9;
    OP   DIGITS = ( INT n, INT base )[]INT:
         IF   INT v := ABS n;
              v < base
         THEN v # single dogit #
         ELSE   # multiple digits #
            [ 1 : 10 ]INT result;
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
    # print the palendromic primes in the base 16 #
    STRING base digits = "0123456789ABCDEF";
    FOR n TO UPB prime DO
        IF prime[ n ] THEN
            # have a prime #
            IF []INT d = n DIGITS 16;
               PALINDROMIC d
            THEN
                # the prime is palindromic in base 16 #
                print( ( " " ) );
                FOR c FROM LWB d TO UPB d DO print( ( base digits[ d[ c ] + 1 ] ) ) OD
            FI
        FI
    OD;
    print( ( newline ) )
END
