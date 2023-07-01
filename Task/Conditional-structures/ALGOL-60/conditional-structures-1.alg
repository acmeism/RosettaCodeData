    'IF' I=1 'THEN' OUTINTEGER(1,I);

    'IF' I<J 'THEN' OUTSTRING(1,'(' : I<J')')
             'ELSE' OUTSTRING(1,'(' : I>=J')');

    'IF' I>=J 'THEN' 'BEGIN'
        OUTSTRING(1,'(' I=')');
        OUTINTEGER(1,I)
    'END'
    'ELSE' 'BEGIN'
        OUTSTRING(1,'(' J=')');
        OUTINTEGER(1,J)
    'END'
