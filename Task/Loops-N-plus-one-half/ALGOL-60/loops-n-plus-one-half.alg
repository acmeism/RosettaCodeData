'BEGIN'
  'COMMENT' Loops N plus one half - Algol60 - 20/06/2018;
  'INTEGER' I;
  'FOR' I:=1 'STEP' 1 'UNTIL' 10 'DO' 'BEGIN'
    OUTINTEGER(1,I);
    'IF' I 'NOTEQUAL' 10 'THEN' OUTSTRING(1,'(', ')')
  'END'
'END'
