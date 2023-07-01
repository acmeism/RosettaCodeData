#!/usr/local/bin/a68g --script #
# -*- coding: utf-8 -*- #

# UNICHAR/UNICODE must be printed using REPR to convert to UTF8 #

MODE UNICHAR = STRUCT(BITS #31# bits); # assuming bits width >=31 #
MODE UNICODE = FLEX[0]UNICHAR;

OP INITUNICHAR = (BITS bits)UNICHAR: (UNICHAR out; bits OF out := #ABS# bits; out);
OP INITUNICHAR = (CHAR char)UNICHAR: (UNICHAR out; bits OF out := BIN ABS char; out);
OP INITBITS = (UNICHAR unichar)BITS: #BIN# bits OF unichar;

PROC raise value error = ([]UNION(FORMAT,BITS,STRING)argv )VOID: (
  putf(stand error, argv); stop
);

MODE YIELDCHAR =    PROC(CHAR)VOID;    MODE GENCHAR =    PROC(YIELDCHAR)VOID;
MODE YIELDUNICHAR = PROC(UNICHAR)VOID; MODE GENUNICHAR = PROC(YIELDUNICHAR)VOID;

PRIO DOCONV = 1;

# Convert a stream of UNICHAR into a stream of UTFCHAR #
OP DOCONV = (GENUNICHAR gen unichar, YIELDCHAR yield)VOID:(
  BITS non ascii = NOT 2r1111111;
# FOR UNICHAR unichar IN # gen unichar( # ) DO ( #
##   (UNICHAR unichar)VOID: (
    BITS bits := INITBITS unichar;
    IF (bits AND non ascii) = 2r0 THEN # ascii #
      yield(REPR ABS bits)
    ELSE
      FLEX[6]CHAR buf := "?"*6; # initialise work around #
      INT bytes := 0;
      BITS byte lead bits = 2r10000000;
      FOR ofs FROM UPB buf BY -1 WHILE
        bytes +:= 1;
        buf[ofs]:= REPR ABS (byte lead bits OR bits AND 2r111111);
        bits := bits SHR 6;
    # WHILE # bits NE 2r0 DO
        SKIP
      OD;
      BITS first byte lead bits = BIN (ABS(2r1 SHL bytes)-2) SHL (UPB buf - bytes + 1);
      buf := buf[UPB buf-bytes+1:];
      buf[1] := REPR ABS(BIN ABS buf[1] OR first byte lead bits);
      FOR i TO UPB buf DO yield(buf[i]) OD
    FI
# OD # ))
);

# Convert a STRING into a stream of UNICHAR #
OP DOCONV = (STRING string, YIELDUNICHAR yield)VOID: (
  PROC gen char = (YIELDCHAR yield)VOID:
    FOR i FROM LWB string TO UPB string DO yield(string[i]) OD;
  gen char DOCONV yield
);

CO Prosser/Thompson UTF8 encoding scheme
Bits Last code point Byte 1   Byte 2   Byte 3   Byte 4   Byte 5   Byte 6
 7   U+007F          0xxxxxxx
11   U+07FF          110xxxxx 10xxxxxx
16   U+FFFF          1110xxxx 10xxxxxx 10xxxxxx
21   U+1FFFFF        11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
26   U+3FFFFFF       111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
31   U+7FFFFFFF      1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
END CO

# Quickly calculate the length of the UTF8 encoded string #
PROC upb utf8 = (STRING utf8 string)INT:(
  INT bytes to go := 0;
  INT upb := 0;
  FOR i FROM LWB utf8 string TO UPB utf8 string DO
    CHAR byte := utf8 string[i];
    IF bytes to go = 0 THEN # start new utf char #
      bytes to go :=
        IF   ABS byte <= ABS 2r01111111 THEN 1 #  7 bits #
        ELIF ABS byte <= ABS 2r11011111 THEN 2 # 11 bits #
        ELIF ABS byte <= ABS 2r11101111 THEN 3 # 16 bits #
        ELIF ABS byte <= ABS 2r11110111 THEN 4 # 21 bits #
        ELIF ABS byte <= ABS 2r11111011 THEN 5 # 26 bits #
        ELIF ABS byte <= ABS 2r11111101 THEN 6 # 31 bits #
        ELSE raise value error(("Invalid UTF-8 bytes", BIN ABS byte)); ~ FI
    FI;
    bytes to go -:= 1; # skip over trailing bytes #
    IF bytes to go = 0 THEN upb +:= 1 FI
  OD;
  upb
);

# Convert a stream of CHAR into a stream of UNICHAR #
OP DOCONV = (GENCHAR gen char, YIELDUNICHAR yield)VOID: (
  INT bytes to go := 0;
  INT lshift;
  BITS mask, out;

  # FOR CHAR byte IN # gen char( # ) DO ( #
  ##   (CHAR byte)VOID: (
      INT bits := ABS byte;
      IF bytes to go = 0 THEN # start new unichar #
        bytes to go :=
          IF   bits <= ABS 2r01111111 THEN 1 #  7 bits #
          ELIF bits <= ABS 2r11011111 THEN 2 # 11 bits #
          ELIF bits <= ABS 2r11101111 THEN 3 # 16 bits #
          ELIF bits <= ABS 2r11110111 THEN 4 # 21 bits #
          ELIF bits <= ABS 2r11111011 THEN 5 # 26 bits #
          ELIF bits <= ABS 2r11111101 THEN 6 # 31 bits #
          ELSE raise value error(("Invalid UTF-8 bytes", BIN bits)); ~ FI;
        IF bytes to go = 1 THEN
          lshift := 7; mask := 2r1111111
        ELSE
          lshift := 7 - bytes to go; mask :=  BIN(ABS(2r1 SHL lshift)-1)
        FI;
        out := mask AND BIN bits;

        lshift := 6; mask := 2r111111 # subsequently pic 6 bits at a time #
      ELSE
        out := (out SHL lshift) OR ( mask AND BIN bits)
      FI;
      bytes to go -:= 1;
      IF bytes to go = 0 THEN yield(INITUNICHAR out) FI
  # OD # ))
);

# Convert a string of UNICHAR into a stream of UTFCHAR #
OP DOCONV = (UNICODE unicode, YIELDCHAR yield)VOID:(
  PROC gen unichar = (YIELDUNICHAR yield)VOID:
    FOR i FROM LWB unicode TO UPB unicode DO yield(unicode[i]) OD;
  gen unichar DOCONV yield
);

# Some convenience/shorthand U operators #
# Convert a BITS into a UNICODE char #
OP U = (BITS bits)UNICHAR:
  INITUNICHAR bits;

# Convert a []BITS into a UNICODE char #
OP U = ([]BITS array bits)[]UNICHAR:(
  [LWB array bits:UPB array bits]UNICHAR out;
  FOR i FROM LWB array bits TO UPB array bits DO bits OF out[i]:=array bits[i] OD;
  out
);

# Convert a CHAR into a UNICODE char #
OP U = (CHAR char)UNICHAR:
  INITUNICHAR char;

# Convert a STRING into a UNICODE string #
OP U = (STRING utf8 string)UNICODE: (
  FLEX[upb utf8(utf8 string)]UNICHAR out;
  INT i := 0;
# FOR UNICHAR char IN # utf8 string DOCONV (
##   (UNICHAR char)VOID:
       out[i+:=1] := char
# OD #);
  out
);

# Convert a UNICODE string into a UTF8 STRING #
OP REPR = (UNICODE string)STRING: (
  STRING out;
# FOR CHAR char IN # string DOCONV (
##   (CHAR char)VOID: (
       out +:= char
# OD #));
  out
);

# define the most useful OPerators on UNICODE CHARacter arrays #
# Note: LWB, UPB and slicing works as per normal #

OP + = (UNICODE a,b)UNICODE: (
  [UPB a + UPB b]UNICHAR out;
  out[:UPB a]:= a; out[UPB a+1:]:= b;
  out
);

OP + = (UNICODE a, UNICHAR b)UNICODE: a+UNICODE(b);
OP + = (UNICHAR a, UNICODE b)UNICODE: UNICODE(a)+b;
OP + = (UNICHAR a,b)UNICODE: UNICODE(a)+b;

# Suffix a character to the end of a UNICODE string #
OP +:= = (REF UNICODE a, UNICODE b)VOID: a := a + b;
OP +:= = (REF UNICODE a, UNICHAR b)VOID: a := a + b;

# Prefix a character to the beginning of a UNICODE string #
OP +=: = (UNICODE b, REF UNICODE a)VOID: a := b + a;
OP +=: = (UNICHAR b, REF UNICODE a)VOID: a := b + a;

OP * = (UNICODE a, INT n)UNICODE: (
  UNICODE out := a;
  FOR i FROM 2 TO n DO out +:= a OD;
  out
);
OP * = (INT n, UNICODE a)UNICODE: a * n;

OP * = (UNICHAR a, INT n)UNICODE: UNICODE(a)*n;
OP * = (INT n, UNICHAR a)UNICODE: n*UNICODE(a);

OP *:= = (REF UNICODE a, INT b)VOID: a := a * b;

# Wirthy Operators #
OP LT = (UNICHAR a,b)BOOL: ABS bits OF a LT ABS bits OF b,
   LE = (UNICHAR a,b)BOOL: ABS bits OF a LE ABS bits OF b,
   EQ = (UNICHAR a,b)BOOL: ABS bits OF a EQ ABS bits OF b,
   NE = (UNICHAR a,b)BOOL: ABS bits OF a NE ABS bits OF b,
   GE = (UNICHAR a,b)BOOL: ABS bits OF a GE ABS bits OF b,
   GT = (UNICHAR a,b)BOOL: ABS bits OF a GT ABS bits OF b;

# ASCII OPerators #
OP <  = (UNICHAR a,b)BOOL: a LT b,
   <= = (UNICHAR a,b)BOOL: a LE b,
    = = (UNICHAR a,b)BOOL: a EQ b,
   /= = (UNICHAR a,b)BOOL: a NE b,
   >= = (UNICHAR a,b)BOOL: a GE b,
   >  = (UNICHAR a,b)BOOL: a GT b;

# Non ASCII OPerators
OP ≤ = (UNICHAR a,b)BOOL: a LE b,
   ≠ = (UNICHAR a,b)BOOL: a NE b,
   ≥ = (UNICHAR a,b)BOOL: a GE b;
#

# Compare two UNICODE strings for equality #
PROC unicode cmp = (UNICODE str a,str b)INT: (

  IF LWB str a > LWB str b THEN exit lt ELIF LWB str a < LWB str b THEN exit gt FI;

  INT min upb = UPB(UPB str a < UPB str b | str a | str b );

  FOR i FROM LWB str a TO min upb DO
    UNICHAR a := str a[i], UNICHAR b := str b[i];
    IF a < b THEN exit lt ELIF a > b THEN exit gt FI
  OD;

  IF UPB str a > UPB str b THEN exit gt ELIF UPB str a < UPB str b THEN exit lt FI;

  exit eq:  0 EXIT
  exit lt: -1 EXIT
  exit gt:  1
);

OP LT = (UNICODE a,b)BOOL: unicode cmp(a,b)< 0,
   LE = (UNICODE a,b)BOOL: unicode cmp(a,b)<=0,
   EQ = (UNICODE a,b)BOOL: unicode cmp(a,b) =0,
   NE = (UNICODE a,b)BOOL: unicode cmp(a,b)/=0,
   GE = (UNICODE a,b)BOOL: unicode cmp(a,b)>=0,
   GT = (UNICODE a,b)BOOL: unicode cmp(a,b)> 0;

# ASCII OPerators #
OP <  = (UNICODE a,b)BOOL: a LT b,
   <= = (UNICODE a,b)BOOL: a LE b,
    = = (UNICODE a,b)BOOL: a EQ b,
   /= = (UNICODE a,b)BOOL: a NE b,
   >= = (UNICODE a,b)BOOL: a GE b,
   >  = (UNICODE a,b)BOOL: a GT b;

# Non ASCII OPerators
OP ≤ = (UNICODE a,b)BOOL: a LE b,
   ≠ = (UNICODE a,b)BOOL: a NE b,
   ≥ = (UNICODE a,b)BOOL: a GE b;
#

COMMENT - Todo: for all UNICODE and UNICHAR
  Add NonASCII OPerators: ×, ×:=,
  Add ASCII Operators: &, &:=, &=:
  Add Wirthy OPerators: PLUSTO, PLUSAB, TIMESAB for UNICODE/UNICHAR,
  Add UNICODE against UNICHAR comparison OPerators,
  Add char_in_string and string_in_string PROCedures,
  Add standard Unicode functions:
    to_upper_case, to_lower_case, unicode_block, char_count,
    get_directionality, get_numeric_value, get_type, is_defined,
    is_digit, is_identifier_ignorable, is_iso_control,
    is_letter, is_letter_or_digit, is_lower_case, is_mirrored,
    is_space_char, is_supplementary_code_point, is_title_case,
    is_unicode_identifier_part, is_unicode_identifier_start,
    is_upper_case, is_valid_code_point, is_whitespace
END COMMENT

test:(

  UNICHAR aircraft := U16r 2708;
  printf(($"aircraft: "$, $"16r"16rdddd$, UNICODE(aircraft), $g$, " => ", REPR UNICODE(aircraft), $l$));

  UNICODE chinese forty two = U16r 56db + U16r 5341 + U16r 4e8c;
  printf(($"chinese forty two: "$, $g$, REPR chinese forty two, ", length string = ", UPB chinese forty two, $l$));

  UNICODE poker = U "A123456789♥♦♣♠JQK";
  printf(($"poker: "$, $g$, REPR poker, ", length string = ", UPB poker, $l$));

  UNICODE selectric := U"×÷≤≥≠¬∨∧⏨→↓↑□⌊⌈⎩⎧○⊥¢";
  printf(($"selectric: "$, $g$, REPR selectric, $l$));
  printf(($"selectric*4: "$, $g$, REPR(selectric*4), $l$));

  print((
    "1 < 2 is ",  U"1" < U"2", ", ",
    "111 < 11 is ",U"111" < U"11", ", ",
    "111 < 12 is ",U"111" < U"12", ", ",
    "♥ < ♦ is ",  U"♥" < U"♦", ", ",
    "♥Q < ♥K is ",U"♥Q" < U"♥K", " & ",
    "♥J < ♥K is ",U"♥J" < U"♥K", new line
  ))

)
