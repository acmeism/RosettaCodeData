'BEGIN' 'COMMENT' Loops/Break - ALGOL60 - 18/06/2018;
  'INTEGER' SEED;
  'INTEGER' 'PROCEDURE' RANDOM(N);
  'VALUE' N; 'INTEGER' N;
  'BEGIN'
    SEED:=(SEED*19157+12347) '/' 21647;
    RANDOM:=SEED-(SEED '/' N)*N+1
  'END' RANDOM;
  'INTEGER' I,J,K;
  SYSACT(1,6,120);SYSACT(1,8,60);SYSACT(1,12,1);'COMMENT' open print;
  SEED:=31567;
  J:=0;
  'FOR' I:=1, I+1 'WHILE' I 'LESS' 100 'DO' 'BEGIN'
    J:=J+1;
    K:=RANDOM(20);
    OUTINTEGER(1,K);
    'IF' J=8 'THEN' 'BEGIN'
       SYSACT(1,14,1);  'COMMENT' skip line;
       J:=0
    'END';
    'IF' K=10 'THEN' 'GOTO' LAB
  'END';
LAB:
  SYSACT(1,14,1);  'COMMENT' skip line;
'END'
