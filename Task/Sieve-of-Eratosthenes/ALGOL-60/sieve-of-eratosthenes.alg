'BEGIN'
    'INTEGER' 'ARRAY' CANDIDATES(/0..1000/);
    'INTEGER' I,J,K;
    'COMMENT' SET LINE-LENGTH=120,SET LINES-PER-PAGE=62,OPEN;
    SYSACT(1,6,120); SYSACT(1,8,62); SYSACT(1,12,1);
    'FOR' I := 0 'STEP' 1 'UNTIL' 1000 'DO'
    'BEGIN'
        CANDIDATES(/I/) := 1;
    'END';
    CANDIDATES(/0/) := 0;
    CANDIDATES(/1/) := 0;
    I := 0;
    'FOR' I := I 'WHILE' I 'LESS' 1000 'DO'
    'BEGIN'
        'FOR' I := I 'WHILE' I 'LESS' 1000
          'AND' CANDIDATES(/I/) 'EQUAL' 0 'DO'
            I := I+1;
        'IF' I 'LESS' 1000 'THEN'
        'BEGIN'
            J := 2;
            K := J*I;
            'FOR' K := K 'WHILE' K 'LESS' 1000 'DO'
            'BEGIN'
                CANDIDATES(/K/) := 0;
                J := J + 1;
                K := J*I;
            'END';
            I := I+1;
            'END'
        'END';
        'FOR' I := 0 'STEP' 1 'UNTIL' 999 'DO'
        'IF' CANDIDATES(/I/) 'NOTEQUAL' 0  'THEN'
        'BEGIN'
            OUTINTEGER(1,I);
            OUTSTRING(1,'(' IS PRIME')');
            'COMMENT' NEW LINE;
            SYSACT(1,14,1)
        'END'
    'END'
'END'
