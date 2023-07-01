 MODE FRAC = STRUCT( INT num #erator#,  den #ominator#);
 FORMAT frac repr = $g(-0)"//"g(-0)$;

 PROC gcd = (INT a, b) INT: # greatest common divisor #
   (a = 0 | b |: b = 0 | a |: ABS a > ABS b  | gcd(b, a MOD b) | gcd(a, b MOD a));

 PROC lcm = (INT a, b)INT: # least common multiple #
   a OVER gcd(a, b) * b;

 PROC raise not implemented error = ([]STRING args)VOID: (
   put(stand error, ("Not implemented error: ",args, newline));
   stop
 );

 PRIO // = 9; # higher then the ** operator #
 OP // = (INT num, den)FRAC: ( # initialise and normalise #
   INT common = gcd(num, den);
   IF den < 0 THEN
     ( -num OVER common, -den OVER common)
   ELSE
     ( num OVER common, den OVER common)
   FI
 );

 OP + = (FRAC a, b)FRAC: (
   INT common = lcm(den OF a, den OF b);
   FRAC result := ( common OVER den OF a * num OF a + common OVER den OF b * num OF b, common );
   num OF result//den OF result
 );

 OP - = (FRAC a, b)FRAC: a + -b,
    * = (FRAC a, b)FRAC: (
   INT num = num OF a * num OF b,
       den = den OF a * den OF b;
   INT common = gcd(num, den);
   (num OVER common) // (den OVER common)
 );

 OP /  = (FRAC a, b)FRAC: a * FRAC(den OF b, num OF b),# real division #
    %  = (FRAC a, b)INT: ENTIER (a / b),               # integer divison #
    %* = (FRAC a, b)FRAC: a/b - FRACINIT ENTIER (a/b), # modulo division #
    ** = (FRAC a, INT exponent)FRAC:
     IF exponent >= 0 THEN
       (num OF a ** exponent, den OF a ** exponent )
     ELSE
       (den OF a ** exponent, num OF a ** exponent )
     FI;

 OP REALINIT = (FRAC frac)REAL: num OF frac / den OF frac,
    FRACINIT = (INT num)FRAC: num // 1,
    FRACINIT = (REAL num)FRAC: (
      # express real number as a fraction # # a future execise! #
      raise not implemented error(("Convert a REAL to a FRAC","!"));
      SKIP
    );

 OP <  = (FRAC a, b)BOOL: num OF (a - b) <  0,
    >  = (FRAC a, b)BOOL: num OF (a - b) >  0,
    <= = (FRAC a, b)BOOL: NOT ( a > b ),
    >= = (FRAC a, b)BOOL: NOT ( a < b ),
    =  = (FRAC a, b)BOOL: (num OF a, den OF a) = (num OF b, den OF b),
    /= = (FRAC a, b)BOOL: (num OF a, den OF a) /= (num OF b, den OF b);

 # Unary operators #
 OP - = (FRAC frac)FRAC: (-num OF frac, den OF frac),
    ABS = (FRAC frac)FRAC: (ABS num OF frac, ABS den OF frac),
    ENTIER = (FRAC frac)INT: (num OF frac OVER den OF frac) * den OF frac;

 COMMENT Operators for extended characters set, and increment/decrement:
 OP +:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a + b ),
    +=: = (FRAC a, REF FRAC b)REF FRAC: ( b := a + b ),
    -:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a - b ),
    *:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a * b ),
    /:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a / b ),
    %:= = (REF FRAC a, FRAC b)REF FRAC: ( a := FRACINIT (a % b) ),
    %*:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a %* b );

 # OP aliases for extended character sets (eg: Unicode, APL, ALCOR and GOST 10859) #
 OP ×  = (FRAC a, b)FRAC: a * b,
    ÷  = (FRAC a, b)INT: a OVER b,
    ÷× = (FRAC a, b)FRAC: a MOD b,
    ÷* = (FRAC a, b)FRAC: a MOD b,
    %× = (FRAC a, b)FRAC: a MOD b,
    ≤  = (FRAC a, b)FRAC: a <= b,
    ≥  = (FRAC a, b)FRAC: a >= b,
    ≠  = (FRAC a, b)BOOL: a /= b,
    ↑  = (FRAC frac, INT exponent)FRAC: frac ** exponent,

    ÷×:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a MOD b ),
    %×:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a MOD b ),
    ÷*:= = (REF FRAC a, FRAC b)REF FRAC: ( a := a MOD b );

 # BOLD aliases for CPU that only support uppercase for 6-bit bytes  - wrist watches #
 OP OVER = (FRAC a, b)INT: a % b,
    MOD = (FRAC a, b)FRAC: a %*b,
    LT = (FRAC a, b)BOOL: a <  b,
    GT = (FRAC a, b)BOOL: a >  b,
    LE = (FRAC a, b)BOOL: a <= b,
    GE = (FRAC a, b)BOOL: a >= b,
    EQ = (FRAC a, b)BOOL: a =  b,
    NE = (FRAC a, b)BOOL: a /= b,
    UP = (FRAC frac, INT exponent)FRAC: frac**exponent;

 # the required standard assignment operators #
 OP PLUSAB  = (REF FRAC a, FRAC b)REF FRAC: ( a +:= b ), # PLUS #
    PLUSTO  = (FRAC a, REF FRAC b)REF FRAC: ( a +=: b ), # PRUS #
    MINUSAB = (REF FRAC a, FRAC b)REF FRAC: ( a *:= b ),
    DIVAB   = (REF FRAC a, FRAC b)REF FRAC: ( a /:= b ),
    OVERAB  = (REF FRAC a, FRAC b)REF FRAC: ( a %:= b ),
    MODAB   = (REF FRAC a, FRAC b)REF FRAC: ( a %*:= b );

END COMMENT
Example: searching for Perfect Numbers.
 FRAC sum:= FRACINIT 0;
 FORMAT perfect = $b(" perfect!","")$;

 FOR i FROM 2 TO 2**19 DO
   INT candidate := i;
   FRAC sum := 1 // candidate;
   REAL real sum := 1 / candidate;
   FOR factor FROM 2 TO ENTIER sqrt(candidate) DO
     IF candidate MOD factor = 0 THEN
       sum :=  sum + 1 // factor + 1 // ( candidate OVER factor);
       real sum +:= 1 / factor + 1 / ( candidate OVER factor)
     FI
   OD;
   IF den OF sum  = 1 THEN
     printf(($"Sum of reciprocal factors of "g(-0)" = "g(-0)" exactly, about "g(0,real width) f(perfect)l$,
             candidate, ENTIER sum, real sum, ENTIER sum = 1))
   FI
 OD
