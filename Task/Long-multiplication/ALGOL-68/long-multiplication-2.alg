MODE DIGIT = INT;
MODE INTEGER = FLEX[0]DIGIT; # an arbitary number of digits #

# "digits" are stored in digit base ten, but 10000 & 2**n (inc hex) can be used #
INT digit base = 1000;

# if possible, then print the digit with one character #
STRING hex digit repr = "0123456789abcdefghijklmnopqrstuvwxyz"[AT 0];
INT digit base digit width = ( digit base <=  UPB hex digit repr + 1 | 1 | 1 + ENTIER log(digit base-1) );

INT next digit = -1; # reverse order so digits appear in "normal" order when printed #

PROC raise value error = ([]STRING args)VOID:
  ( print(("Value Error: ", args, new line)); stop );

PROC raise not implemented error = ([]STRING args)VOID:
  ( print(("Not implemented Error: ", args, new line)); stop );

PROC raise integer not implemented error = (STRING message)INTEGER:
  ( raise not implemented error(("INTEGER ", message)); SKIP );

INT half max int = max int OVER 2;
IF digit base > half max int THEN raise value error("INTEGER addition may fail") FI;

INT sqrt max int = ENTIER sqrt(max int);
IF digit base > sqrt max int THEN raise value error("INTEGER multiplication may fail") FI;

# initialise/cast a INTEGER from a LONG LONG INT #
OP INTEGERINIT = (LONG LONG INT number)INTEGER:(
  [1 + ENTIER (SHORTEN SHORTEN long long log(ABS number) / log(digit base))]DIGIT out;
  LONG LONG INT carry := number;
  FOR digit out FROM UPB out BY next digit TO LWB out DO
    LONG LONG INT prev carry := carry;
    carry %:= digit base; # avoid MOD as it doesn't under handle -ve numbers #
    out[digit out] := SHORTEN SHORTEN (prev carry - carry * digit base)
  OD;
  out
);

# initialise/cast a INTEGER from an LONG INT #
OP INTEGERINIT = (LONG INT number)INTEGER: INTEGERINIT LENG number;

# initialise/cast a INTEGER from an INT #
OP INTEGERINIT = (INT number)INTEGER: INTEGERINIT LENG LENG number;

# remove leading zero "digits" #
OP NORMALISE = ([]DIGIT number)INTEGER: (
  INT leading zeros := LWB number - 1;
  FOR digit number FROM LWB number TO UPB number
    WHILE number[digit number] = 0 DO leading zeros := digit number OD;
  IF leading zeros = UPB number THEN 0 ELSE number[leading zeros+1:] FI
);

#####################################################################
  Define a standard representation for the INTEGER mode.  Note: this is
  rather crude because for a large "digit base" the number is represented as
  blocks of decimals. It works nicely for powers of ten (10,100,1000,...),
  but for most larger bases (greater then 35) the repr will be a surprise.
#####################################################################
OP REPR = (DIGIT d)STRING:
    IF digit base > UPB hex digit repr THEN
      STRING out := whole(ABS d, -digit base digit width);
# Replace spaces with zeros #
      FOR digit out FROM LWB out TO UPB out DO
        IF out[digit out] = " " THEN out[digit out] := "0" FI
      OD;
      out
    ELSE # small enough to represent as ASCII (hex) characters #
      hex digit repr[ABS d]
    FI;

OP REPR = (INTEGER number)STRING:(
  STRING sep = ( digit base digit width > 1 | "," | "" );
  INT width := digit base digit width + UPB sep;
  [width * UPB number - UPB sep]CHAR out;
  INT leading zeros := LWB out - 1;
  FOR digit TO UPB number DO
    INT start := digit * width - width + 1;
    out[start:start+digit base digit width-1] := REPR number[digit];
    IF digit base digit width /= 1 & digit /= UPB number THEN
      out[start+digit base digit width] := ","
    FI
  OD;

# eliminate leading zeros #
  FOR digit out FROM LWB out TO UPB out
    WHILE out[digit out] = "0" OR out[digit out] = sep
  DO leading zeros := digit out OD;

  CHAR sign = ( number[1]<0 | "-" | "+" );
# finally return the semi-normalised result #
  IF leading zeros = UPB out THEN "0" ELSE sign + out[leading zeros+1:] FI
);
