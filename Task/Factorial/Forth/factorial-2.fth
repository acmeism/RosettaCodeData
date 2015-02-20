: factorial ( n -- d )
    dup 33 u> -24 and throw
    dup 2 < IF
        drop 1.
    ELSE
        1.
        rot 1+ 2 DO
            i 1 m*/
        LOOP
    THEN ;

33 factorial d. 8683317618811886495518194401280000000  ok
-5 factorial d.
:2: Invalid numeric argument
