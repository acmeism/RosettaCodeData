(
  STRING line;
  INT count := 0, errno;
  BOOL input complete := FALSE;
  SEMA output throttle = LEVEL 0, input throttle = LEVEL 1;

  FILE input txt;
  errno := open(input txt, "input.txt", stand in channel);

  PROC call back done = (REF FILE f) BOOL: ( input complete := TRUE );
  on logical file end(input txt, call back done);

  PAR (
    WHILE
      DOWN input throttle;
      get(input txt,(line, new line));
      UP output throttle;
      NOT input complete
    DO
      count+:=1
    OD
  ,
    WHILE
      DOWN output throttle;
      NOT input complete
    DO
      print((line, new line));
      UP input throttle
    OD
  );
  print((count))
)
