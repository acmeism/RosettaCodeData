PR READ "Template.Big_float_BCD.Base.a68" PR # [[rc:Generalised floating point addition]] #

################################################################
# First: define the attributes of the arithmetic we are using. #
################################################################
arithmetic := (
  # balanced = # TRUE,
  # carry = # TRUE,
  # base = # 3, # width = # 1, # places = # 81, # order = # -1,
  # repr = # USTRING("-","0","+")[@-1]
);

OP INITDIGIT = (CHAR c)DIGIT: (
  DIGIT out;
  digit OF out :=
    IF   c = "+" THEN +1
    ELIF c = "0" THEN  0
    ELIF c = "-" THEN -1
    ELSE raise value error("Unknown digit :"""+c+""""); SKIP
    FI;
  out
);

OP INITBIGREAL = (STRING s)BIGREAL: (
  BIGREAL out;
  BIGREAL base of arithmetic = INITBIGREAL base OF arithmetic; # Todo: Opt #
  INT point := UPB s; # put the point on the extreme right #
  FOR place FROM LWB s TO UPB s DO
    IF s[place]="." THEN
      point := place
    ELSE
      out := out SHR digit order OF arithmetic + INITDIGIT s[place]
    FI
  OD;
  out SHR (UPB s-point)
);
