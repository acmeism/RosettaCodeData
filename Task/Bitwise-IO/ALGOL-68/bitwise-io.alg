# NIBBLEs are of any width, eg 1-bit OR 4-bits etc. #
MODE NIBBLE = STRUCT(INT width, BITS bits);

PRIO << = 8, >> = 8; # define C style shift opertors #
OP << = (BITS bits, INT shift)BITS: bits SHL shift;
OP >> = (BITS bits, INT shift)BITS: bits SHR shift;

# define nibble opertors for left/right shift and append #
OP << = (NIBBLE nibble, INT shift)NIBBLE:
  (width OF nibble + shift, bits OF nibble << shift);

OP >> = (NIBBLE nibble, INT shift)NIBBLE:
  (width OF nibble - shift, bits OF nibble >> shift);

OP +:= = (REF NIBBLE lhs, NIBBLE rhs)REF NIBBLE: (
  BITS rhs mask := BIN(ABS(2r1 << width OF rhs)-1);
  lhs := ( width OF lhs + width OF rhs, bits OF lhs << width OF rhs OR bits OF rhs AND rhs mask)
);

# define MODEs for generating NIBBLE streams and yielding NIBBLEs #
MODE YIELDNIBBLE = PROC(NIBBLE)VOID;
MODE GENNIBBLE = PROC(YIELDNIBBLE)VOID;

PROC gen resize nibble = (
  INT out width,
  GENNIBBLE gen nibble,
  YIELDNIBBLE yield
)VOID:(
     NIBBLE buf := (0, 2r0), out;
     BITS out mask := BIN(ABS(2r1 << out width)-1);
# FOR NIBBLE nibble IN # gen nibble( # ) DO #
##   (NIBBLE in nibble)VOID:(
    buf +:= in nibble;
    WHILE width OF buf >= out width DO
      out := buf >> ( width OF buf - out width);
      width OF buf -:= out width; # trim 'out' from buf #
      yield((out width, bits OF out AND out mask))
    OD
# OD # ))
);

# Routines for joining strings and generating a stream of nibbles #

PROC gen nibble from 7bit chars = (STRING string, YIELDNIBBLE yield)VOID:
  FOR key FROM LWB string TO UPB string DO yield((7, BIN ABS string[key])) OD;

PROC gen nibble from 8bit chars = (STRING string, YIELDNIBBLE yield)VOID:
  FOR key FROM LWB string TO UPB string DO yield((8,BIN ABS string[key])) OD;

PROC gen join = ([]STRING strings, STRING new line, YIELDNIBBLE yield)VOID:
   FOR key FROM LWB strings TO UPB strings DO
     gen nibble from 8bit chars(strings[key]+new line, yield)
   OD;

# Two tables for uuencoding 6bits in printable ASCII chacters #

[0:63]CHAR encode uue 6bit:= # [0:63] => CHAR64 #
  "`!""#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_"[@0];

[0:255]BITS decode uue 6bit; # CHAR64 => [0:63] #
  FOR key FROM LWB encode uue 6bit TO UPB encode uue 6bit DO
    decode uue 6bit[ABS encode uue 6bit[key]] := BIN key
  OD;
  decode uue 6bit[ABS " "] := 2r0; # extra #

# Some basic examples #

PROC example uudecode nibble stream = VOID:(

  []STRING encoded uue 6bit hello world = (
    ":&5L;&\L('=O<FQD""DAE;&QO+""!W;W)L9""$*1V]O9&)Y92P@8W)U96P@=V]R",
    ";&0*22=M(&QE879I;F<@>6]U('1O9&%Y""D=O;V1B>64L(&=O;V1B>64L(&=O",
    ";V1B>64@""@``"
  );

  PROC gen join hello world = (YIELDNIBBLE yield)VOID:
  # FOR NIBBLE nibble IN # gen join(encoded uue 6bit hello world, "", # ) DO #
  ##   (NIBBLE nibble)VOID:(
    yield((6, decode uue 6bit[ABS bits OF nibble]))
  # OD # ));

  print(("Decode uue 6bit NIBBLEs into 8bit CHARs:", new line));

# FOR NIBBLE nibble IN # gen resize nibble(8, gen join hello world, # ) DO ( #
##   (NIBBLE nibble)VOID:(
    print(REPR ABS bits OF nibble)
# OD # ))
);

PROC example uuencode nibble stream = VOID: (
  []STRING hello world = (
    "hello, world",
    "Hello, world!",
    "Goodbye, cruel world",
    "I'm leaving you today",
    "Goodbye, goodbye, goodbye "
  );

  PROC gen join hello world = (YIELDNIBBLE yield)VOID:
    gen join(hello world, REPR ABS 8r12, yield); # 8r12 = ASCII new line #

  print((new line, "Encode 8bit CHARs into uue 6bit NIBBLEs:", new line));
  INT count := 0;
# FOR NIBBLE nibble IN # gen resize nibble(6, gen join hello world, # ) DO ( #
##   (NIBBLE nibble)VOID:(
    print(encode uue 6bit[ABS bits OF nibble]);
    count+:=1;
    IF count MOD 60 = 0 THEN print(newline) FI
# OD # ));
    print(new line); print(new line)
);

PROC example compress 7bit chars = VOID: (
  STRING example 7bit string = "STRING & ABACUS";

  print(("Convert 7bit ASCII CHARS to a 1bit stream: ",new line,
          example 7bit string + " => "));

  PROC gen example 7bit string = (YIELDNIBBLE yield)VOID:
    gen nibble from 7bit chars(example 7bit string,yield);

# FOR NIBBLE nibble IN # gen resize nibble(1, gen example 7bit string, # ) DO ( #
##   (NIBBLE nibble)VOID: (
    print(whole(ABS bits OF nibble,0))
# OD # ));
  print(new line)
);

example uudecode nibble stream;
example uuencode nibble stream;
example compress 7bit chars
