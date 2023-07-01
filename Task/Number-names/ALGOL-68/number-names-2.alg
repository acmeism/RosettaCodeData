MODE EXCEPTION = STRUCT(STRING name, PROC VOID handler);
EXCEPTION value error = ("Value Error", stop);

PROC raise = (EXCEPTION exception, STRING str error)VOID: (
  put(stand error, (name OF exception,": ",str error, new line));
  handler OF exception
);

MODE LINT = LONG LONG INT;

BOOL locale euro := TRUE;

PROC spell integer = (LINT n)STRING: (
    []STRING tens = []STRING (~, ~, "twenty", "thirty", "forty",
            "fifty", "sixty", "seventy", "eighty", "ninety")[@0];

    []STRING small = []STRING ("zero", "one", "two", "three", "four", "five",
             "six", "seven", "eight", "nine", "ten", "eleven",
             "twelve", "thirteen", "fourteen", "fifteen",
             "sixteen", "seventeen", "eighteen", "nineteen")[@0];

    []STRING bl = []STRING (~, ~, "m", "b", "tr", "quadr",
          "quint", "sext", "sept", "oct", "non", "dec")[@0];

    PROC nonzero = (STRING c, LINT n)STRING:
        IF n = 0 THEN "" ELSE c + spell integer(n) FI;

    PROC big =(INT e, LINT n)STRING:
        spell integer(n) +
        CASE e+1 IN
        #0# "",
        #1# " thousand"
        OUT
            " " +
            IF locale euro THEN # handle millard, billard & trillard etc #
              bl[e OVER 2 + 1 ]+"ill" + CASE e MOD 2 IN "ard" OUT "ion" ESAC
            ELSE
              bl[e]+"illion"
            FI
        ESAC;

    PROC base1000 rev = (LINT in n, PROC (INT,LINT)VOID yield)VOID: (
        # generates the value of the digits of n in base 1000 #
        # (i.e. 3-digit chunks), in reverse. #
        LINT n := in n;
        FOR e FROM 0 WHILE n /= 0 DO
            LINT r = n MOD 1000;
                n := n OVER 1000;
            yield(e, r)
        OD
    );

    IF n < 1000 THEN
      INT ssn := SHORTEN SHORTEN n;
      IF ssn < 0 THEN
        raise (value error, "spell integer: negative input"); ~
      ELIF ssn < 20 THEN
        small[ssn]
      ELIF ssn < 100 THEN
        INT a = ssn OVER 10,
            b = ssn MOD 10;
        tens[a] + nonzero("-", b)
      ELIF ssn < 1000 THEN
        INT a = ssn OVER 100,
            b = ssn MOD 100;
        small[a] + " hundred" + ( b NE 0 | " and" | "") + nonzero(" ", b)
      FI
    ELSE
        STRING out := "", sep:="";
      # FOR     e,      x IN # base1000 rev(n, # DO #
           (INT e, LINT x)VOID:
                IF x NE 0 THEN
                    big(e,x) + sep +=: out;
                    sep := IF e = 0 AND x < 100 THEN " and " ELSE ", " FI
                FI
       )
     # OD #;
       out
    FI
);

PROC example = (LINT n)VOID:
  print((whole(n,0),": ", spell integer(n), new line));

# examples #
LINT prod := 0;
FOR i TO 6 DO prod := prod * 10**i + i; example(prod) OD;

example(1278); example(1572); example(2010)
