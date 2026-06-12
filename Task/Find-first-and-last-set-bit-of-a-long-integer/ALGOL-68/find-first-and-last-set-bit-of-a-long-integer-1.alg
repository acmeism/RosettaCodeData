INT lbits width = UPB []BOOL(LBITS(2r0));

OP LWB = (BITS in x)INT: bits width - RUPB in x;

OP RUPB = (BITS in x)INT:
  ### 32 bit LWB Find Lower Set Bit using an unrolled loop ###
# Note: BITS ELEM 1 is actually numerically the Most Significant Bit!! #
  IF in x = 2r0 THEN
    -1 # EXIT #
  ELSE
    BITS x := in x, out := 2r0;
    IF(x AND NOT 2r1111111111111111)/=2r0 THEN x := x SHR 16; out := out OR 2r10000 FI;
    IF(x AND NOT 2r11111111)        /=2r0 THEN x := x SHR  8; out := out OR 2r1000 FI;
    IF(x AND NOT 2r1111)            /=2r0 THEN x := x SHR  4; out := out OR 2r100 FI;
    IF(x AND NOT 2r11)              /=2r0 THEN x := x SHR  2; out := out OR 2r10 FI;
    IF(x AND NOT 2r1)               /=2r0 THEN                out := out OR 2r1 FI;
    ABS out # EXIT #
  FI;

OP LWB = (LBITS in x)INT: lbits width - RUPB in x;

OP RUPB = (LBITS in x)INT:
  ### Generalised Find Lower Set Bit using a loop ###
# Note: BITS ELEM 32 is actually numerically the Least Significant Bit!! #
  IF in x = 2r0 THEN
    -1 # EXIT #
  ELSE
    LBITS x := in x;
    BITS
      out bit := BIN 1 SHL (bits width - LWB BIN lbits width),
      out := BIN 0;
    WHILE
      LBITS mask := NOT BIN (ABS (LONG 2r1 SHL ABS out bit) - 1);
      IF(x AND mask) /= 2r0 THEN
        x := x SHR ABS out bit;
        out := out OR out bit FI;
      out bit := out bit SHR 1;
  # WHILE # out bit /= 2r0 DO SKIP OD;
    ABS out # EXIT #
  FI;

OP UPB = (BITS in x)INT: bits width - RLWB in x;

OP RLWB = (BITS in x)INT:
  ### 32 bit Find Upper Set Bit using an unrolled loop ###
# Note: BITS ELEM 1 is actually numerically the Most Significant Bit!! #
  IF in x = 2r0 THEN
    0 # EXIT #
  ELSE
    BITS x := in x, out := 2r0;
    IF(x AND 2r1111111111111111)=2r0 THEN x := x SHR 16; out := out OR 2r10000 FI;
    IF(x AND 2r11111111)        =2r0 THEN x := x SHR  8; out := out OR 2r1000 FI;
    IF(x AND 2r1111)            =2r0 THEN x := x SHR  4; out := out OR 2r100 FI;
    IF(x AND 2r11)              =2r0 THEN x := x SHR  2; out := out OR 2r10 FI;
    IF(x AND 2r1)               =2r0 THEN                out := out OR 2r1 FI;
    ABS out # EXIT #
  FI;

OP UPB = (LBITS in x)INT: lbits width - RLWB in x;

OP RLWB = (LBITS in x)INT:
  ### Generalised Find Upper Set Bit using a loop ###
# Note: BITS ELEM 1 is actually numerically the Most Significant Bit!! #
  IF in x = 2r0 THEN
    0 # EXIT #
  ELSE
    LBITS x := in x;
    BITS
      out bit := BIN 1 SHL (bits width - LWB BIN lbits width),
      out := BIN 0;
    WHILE
      LBITS mask := BIN (ABS (LONG 2r1 SHL ABS out bit) - 1);
      IF(x AND mask) = 2r0 THEN
        x := x SHR ABS out bit;
        out := out OR out bit FI;
      out bit := out bit SHR 1;
  # WHILE # out bit /= 2r0 DO SKIP OD;
    ABS out # EXIT #
  FI;
