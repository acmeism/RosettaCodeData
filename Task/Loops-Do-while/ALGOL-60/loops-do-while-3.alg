COMMENT Loops/Do-while;

BEGIN
INTEGER i;
i := 0;
REPEAT
  i := i + 1;
  write(1, i);
  skip(1)
UNTIL i MOD 6 = 0
END
FINISH
