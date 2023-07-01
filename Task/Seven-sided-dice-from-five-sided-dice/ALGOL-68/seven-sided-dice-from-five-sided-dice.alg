PROC dice5 = INT:
  1 + ENTIER (5*random);

PROC mulby5 = (INT n)INT:
   ABS (BIN n SHL 2) + n;

PROC dice7 = INT: (
  INT d55 := 0;
  INT m := 1;
  WHILE
    m := ABS ((2r1 AND BIN m) SHL 2) + ABS (BIN m SHR 1);  # repeats 4 - 2 - 1 #
    d55 := mulby5(mulby5(d55)) + mulby5(dice5) + dice5 - 6;
# WHILE # d55 < m DO SKIP OD;

  m := 1;
  WHILE d55>0 DO
    d55 +:= m;
    m := ABS (BIN d55 AND 2r111); # modulas by 8 #
    d55 := ABS (BIN d55 SHR 3)    # divide by 8 #
  OD;
  m
);

PROC distcheck = (PROC INT dice, INT count, upb)VOID: (
  [upb]INT sum; FOR i TO UPB sum DO sum[i] := 0 OD;
  FOR i TO count DO sum[dice]+:=1 OD;
  FOR i TO UPB sum WHILE print(whole(sum[i],0)); i /= UPB sum DO print(", ") OD;
  print(new line)
);

main:
(
  distcheck(dice5, 1000000, 5);
  distcheck(dice7, 1000000, 7)
)
