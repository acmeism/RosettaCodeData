CO BF>
>++++++++[<+++++++++>-]<.>>+>+>++>[-]+<[>[->+<<++++>]<<]>.+++++++..+++.>>+++++++.<<<[[-]<[-]>]<+++++++++++++++.>>.+++.------.--------.>>+.>++++.
CO
BEGIN
  MODE DADDR = INT; # data address #
  MODE DATA  = INT;
  DATA zero  = 0;
  [-255:255]DATA data;  # finite data space #
  FOR i FROM LWB data TO UPB data DO data[i] := zero OD;
  DADDR addr := ( UPB data + LWB data ) OVER 2;

  addr +:= 1;
  data[ addr ] +:= 8;
  WHILE data[ addr ] /= zero DO
    addr -:= 1;
    data[ addr ] +:= 9;
    addr +:= 1;
    data[ addr ] -:= 1
  OD;
  addr -:= 1;
  print( ( REPR data[ addr ] ) );
  addr +:= 2;
  data[ addr ] +:= 1;
  addr +:= 1;
  data[ addr ] +:= 1;
  addr +:= 1;
  data[ addr ] +:= 2;
  addr +:= 1;
  WHILE data[ addr ] /= zero DO
    data[ addr ] -:= 1
  OD;
  data[ addr ] +:= 1;
  addr -:= 1;
  WHILE data[ addr ] /= zero DO
    addr +:= 1;
    WHILE data[ addr ] /= zero DO
      data[ addr ] -:= 1;
      addr +:= 1;
      data[ addr ] +:= 1;
      addr -:= 2;
      data[ addr ] +:= 4;
      addr +:= 1
    OD;
    addr -:= 2
  OD;
  addr +:= 1;
  print( ( REPR data[ addr ] ) );
  data[ addr ] +:= 7;
  print( ( REPR data[ addr ] ) );
  print( ( REPR data[ addr ] ) );
  data[ addr ] +:= 3;
  print( ( REPR data[ addr ] ) );
  addr +:= 2;
  data[ addr ] +:= 7;
  print( ( REPR data[ addr ] ) );
  addr -:= 3;
  WHILE data[ addr ] /= zero DO
    WHILE data[ addr ] /= zero DO
      data[ addr ] -:= 1
    OD;
    addr -:= 1;
    WHILE data[ addr ] /= zero DO
      data[ addr ] -:= 1
    OD;
    addr +:= 1
  OD;
  addr -:= 1;
  data[ addr ] +:= 15;
  print( ( REPR data[ addr ] ) );
  addr +:= 2;
  print( ( REPR data[ addr ] ) );
  data[ addr ] +:= 3;
  print( ( REPR data[ addr ] ) );
  data[ addr ] -:= 6;
  print( ( REPR data[ addr ] ) );
  data[ addr ] -:= 8;
  print( ( REPR data[ addr ] ) );
  addr +:= 2;
  data[ addr ] +:= 1;
  print( ( REPR data[ addr ] ) );
  addr +:= 1;
  data[ addr ] +:= 4;
  print( ( REPR data[ addr ] ) )
END
