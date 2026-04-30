BEGIN # Jugglar sequences - starting with a[0] = n, a[k+1] = floor(sqrt(a[k])) if a[k] is even #
      #                                                    = floor(sqrt(a[k]))*a[k] otherwise  #

    # find the number of terms required to reach a[n] = 1, the maximum value of the sequence   #
    # before it reaches 1 and the index at which the maximum was first reached                 #

    print( ( " n  l[n]            h[n] i[n]", newline ) );
    print( ( "=============================", newline ) );
    FOR a0 FROM 20 TO 39 DO
        INT ak := a0, amax := 0, aindex := 0, mindex := 0;
        WHILE ak /= 1 DO
            IF amax < ak THEN
                amax   := ak;
                mindex := aindex
            FI;
            aindex +:= 1;
            REAL root ak = sqrt( ak );
            ak := ENTIER IF ODD ak THEN root ak * ak ELSE root ak FI
        OD;
        print( ( whole( a0, -2 ), whole( aindex, -5 ), whole( amax, -16 ), whole( mindex, -5 ), newline ) )
    OD

END
