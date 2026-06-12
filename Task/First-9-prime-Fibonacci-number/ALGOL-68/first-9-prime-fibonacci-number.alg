BEGIN # show the first 9 prime fibonacci numbers #
    PR read "primes.incl.a68" PR # include prime utilities #
    INT p count := 0;
    INT prev    := 0;
    INT curr    := 1;
    WHILE p count < 9 DO
        INT next = prev + curr;
        prev    := curr;
        curr    := next;
        IF is probably prime( curr ) THEN
            # have a prime fibonacci number #
            p count +:= 1;
            print( ( " ", whole( curr, 0 ) ) )
        FI
    OD
END
