'BEGIN' 'COMMENT' Loops DoWhile  - Algol60 - 22/06/2018;
  'INTEGER' I;
  I:=0;
LOOP:
    I:=I+1;
    OUTINTEGER(1,I);
    'IF' I=I'/'6*6 'THEN' 'GOTO' ENDLOOP;
  'GOTO' LOOP;
ENDLOOP:
'END'
