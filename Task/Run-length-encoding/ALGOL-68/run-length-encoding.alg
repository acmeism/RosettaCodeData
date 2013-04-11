STRING input := "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW";
STRING output := "12W1B12W3B24W1B14W";

MODE YIELDCHAR = PROC(CHAR)VOID;
MODE GENCHAR = PROC(YIELDCHAR)VOID;

PROC gen char string = (REF STRING s, YIELDCHAR yield)VOID:
  FOR i FROM LWB s TO UPB s DO yield(s[i]) OD;

CO
# Note: The following 2 lines use currying. This not supported by ELLA ALGOL 68RS #
GENCHAR input seq = gen char string(input,),
        output seq = gen char string(output,);
END CO

GENCHAR
  input seq = (YIELDCHAR yield)VOID: gen char string(input, yield),
  output seq = (YIELDCHAR yield)VOID: gen char string(output, yield);

PROC gen encode = (GENCHAR gen char, YIELDCHAR yield)VOID: (
  INT count := 0;
  CHAR prev;
# FOR CHAR c IN # gen char( # ) DO ( #
##   (CHAR c)VOID: (
      IF count = 0 THEN
        count := 1;
        prev := c
      ELIF c NE prev THEN
        STRING str count := whole(count,0);
        gen char string(str count, yield); count := 1;
        yield(prev); prev := c
      ELSE
        count +:=1
      FI
# OD # ));
  IF count NE 0 THEN
    STRING str count := whole(count,0);
    gen char string(str count,yield);
    yield(prev)
  FI
);

STRING zero2nine = "0123456789";

PROC gen decode = (GENCHAR gen char, YIELDCHAR yield)VOID: (
  INT repeat := 0;
# FOR CHAR c IN # gen char( # ) DO ( #
##   (CHAR c)VOID: (
    IF char in string(c, LOC INT, zero2nine) THEN
      repeat := repeat*10 + ABS c - ABS "0"
    ELSE
      FOR i TO repeat DO yield(c) OD;
      repeat := 0
    FI
# OD #  ))
);

# iterate through input string #
print("Encode input: ");
# FOR CHAR c IN # gen encode(input seq, # ) DO ( #
##   (CHAR c)VOID:
    print(c)
# OD # );
print(new line);

# iterate through output string #
print("Decode output: ");
# FOR CHAR c IN # gen decode(output seq, # ) DO ( #
##   (CHAR c)VOID:
    print(c)
# OD # );
print(new line)
