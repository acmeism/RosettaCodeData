 # assume max int <= ABS - max negative int #
 INT max bounded = ( LENG max int * max int > long max int | ENTIER sqrt(max int) | max int );

 MODE RANGE = STRUCT(INT lwb, upb);
 MODE BOUNDED = STRUCT(INT value, RANGE range);
 FORMAT bounded repr = $g"["g(-0)":"g(-0)"]"$;

 # Define some useful operators for looping over ranges #
 OP LWB = (RANGE range)INT: lwb OF range,
    UPB = (RANGE range)INT: upb OF range,
    LWB = (BOUNDED bounded)INT: lwb OF range OF bounded,
    UPB = (BOUNDED bounded)INT: upb OF range OF bounded;

 PROC raise exception = ([]STRING args)VOID: (
   put(stand error, ("exception: ",args, newline));
   stop
 );

 PROC raise not implemented error := ([]STRING args)VOID: raise exception(args);
 PROC raise bounds error := ([]STRING args)VOID: raise exception(args);

 PRIO MIN=9, MAX=9;
 OP MIN = ([]INT list)INT: (
   INT out:= list[LWB list];
   FOR index FROM LWB list+1 TO UPB list DO IF list[index]<out THEN out :=list[index] FI OD;
   out
 );
 OP MAX = ([]INT list)INT: (
   INT out:= list[LWB list];
   FOR index FROM LWB list+1 TO UPB list DO IF list[index]>out THEN out :=list[index] FI OD;
   out
 );

 PRIO ASSERTIN = 6;
 OP ASSERTIN = (INT result, []RANGE range)BOUNDED: (
     BOUNDED out = (result, (MAX lwb OF range, MIN upb OF range));
     IF value OF out < lwb OF range OF out THEN
       raise bounds error(("out of bounds", whole(result, int width)," < [",whole(MAX lwb OF range, int width),":]"))
     ELIF value OF out > upb OF range OF out THEN
       raise bounds error(("out of bounds", whole(result, int width)," > [:",whole(MIN upb OF range, int width),"]"))
     FI;
     out
   ),
   ASSERTIN = (LONG INT result, []RANGE range)BOUNDED: (
     STRUCT (LONG INT value, RANGE range) out = (result, (MAX lwb OF range, MIN upb OF range));
     IF value OF out < lwb OF range OF out THEN
       raise bounds error(("out of bounds", whole(result, long int width)," < [",whole(MAX lwb OF range, int width),":]"))
     ELIF value OF out > upb OF range OF out THEN
       raise bounds error(("out of bounds", whole(result, long int width)," > [:",whole(MIN upb OF range, int width),"]"))
     FI;
     (SHORTEN value OF out, range OF out)
   ),
   ASSERTIN = (INT result, []BOUNDED bounds)BOUNDED: result ASSERTIN range OF bounds,
   ASSERTIN = (LONG INT result, []BOUNDED bounds)BOUNDED: result ASSERTIN range OF bounds;

 INT half max int = max int OVER 2;
 INT sqrt max int = ENTIER sqrt (max int);

 OP + = (BOUNDED a, b)BOUNDED:
          IF ABS value OF a < half max int AND ABS value OF b < half max int THEN
            value OF a + value OF b ASSERTIN []BOUNDED(a,b)
          ELSE
            LENG value OF a + value OF b ASSERTIN []BOUNDED(a,b)
          FI,
    - = (BOUNDED a, b)BOUNDED: value OF a + -value OF b ASSERTIN []BOUNDED(a,b),
    * = (BOUNDED a, b)BOUNDED:
          IF ABS value OF a < sqrt max int AND ABS value OF b < sqrt max int THEN
            value OF a * value OF b ASSERTIN []BOUNDED(a,b)
          ELSE
            LENG value OF a * value OF b ASSERTIN []BOUNDED(a,b)
          FI,
    /  = (BOUNDED a, b)REAL: value OF a / value OF b,
    %  = (BOUNDED a, b)BOUNDED: value OF a % value OF b ASSERTIN []BOUNDED(a,b),
    %* = (BOUNDED a, b)BOUNDED: value OF a %* value OF b ASSERTIN []BOUNDED(a,b),
    ** = (BOUNDED a, INT exponent)BOUNDED: value OF a ** exponent ASSERTIN []BOUNDED(a);

 OP OVER = (INT value, RANGE range)BOUNDED:
   IF ABS lwb OF range > max bounded THEN
     raise bounds error(("out of bounds, ABS", whole(lwb OF range, int width)," > [:",whole(max bounded, int width),"]"));
     SKIP
   ELIF ABS upb OF range > max bounded THEN
     raise bounds error(("out of bounds, ABS", whole(upb OF range, int width)," > [:",whole(max bounded, int width),"]"));
     SKIP
   ELSE
     value ASSERTIN []RANGE(range)
   FI;

 OP INTINIT = (BOUNDED range)REAL: value OF range;

 OP <  = (BOUNDED a, b)BOOL: value OF a < value OF b,
    >  = (BOUNDED a, b)BOOL: value OF a > value OF b,
    <= = (BOUNDED a, b)BOOL: NOT ( value OF a > value OF b ),
    >= = (BOUNDED a, b)BOOL: NOT ( value OF a < value OF b ),
    =  = (BOUNDED a, b)BOOL: value OF a = value OF b,
    /= = (BOUNDED a, b)BOOL: NOT (a = b);

 # Monadic operators #
 OP - = (BOUNDED range)BOUNDED: -value OF range ASSERTIN []BOUNDED(range),
    ABS = (BOUNDED range)BOUNDED: ABS value OF range ASSERTIN []BOUNDED(range);

 COMMENT Operators for extended characters set, and increment/decrement:
 OP +:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a + b ),
    +=: = (BOUNDED a, REF BOUNDED b)REF BOUNDED: ( b := a + b ),
    -:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a - b ),
    *:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a * b ),
    %:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a % b ),
    %*:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a %* b );

 # OP aliases for extended character sets (eg: Unicode, APL, ALCOR and GOST 10859) #
 OP ×  = (BOUNDED a, b)BOUNDED: a * b,
    ÷  = (BOUNDED a, b)INT: a OVER b,
    ÷× = (BOUNDED a, b)BOUNDED: a MOD b,
    ÷* = (BOUNDED a, b)BOUNDED: a MOD b,
    %× = (BOUNDED a, b)BOUNDED: a MOD b,
    ≤  = (BOUNDED a, b)BOUNDED: a <= b,
    ≥  = (BOUNDED a, b)BOUNDED: a >= b,
    ≠  = (BOUNDED a, b)BOOL: a /= b,
    ↑  = (BOUNDED range, INT exponent)BOUNDED: value OF range ** exponent,

    ÷×:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a MOD b ),
    %×:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a MOD b ),
    ÷*:= = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a := a MOD b );

 # BOLD aliases for CPU that only support uppercase for 6-bit bytes  - wrist watches #
 OP OVER = (BOUNDED a, b)INT: a % b,
    MOD = (BOUNDED a, b)BOUNDED: a %*b,
    LT = (BOUNDED a, b)BOOL: a <  b,
    GT = (BOUNDED a, b)BOOL: a >  b,
    LE = (BOUNDED a, b)BOOL: a <= b,
    GE = (BOUNDED a, b)BOOL: a >= b,
    EQ = (BOUNDED a, b)BOOL: a =  b,
    NE = (BOUNDED a, b)BOOL: a /= b,
    UP = (BOUNDED range, INT exponent)BOUNDED: range**exponent;

 # the required standard assignment operators #
 OP PLUSAB  = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a +:= b ), # PLUS #
    PLUSTO  = (BOUNDED a, REF BOUNDED b)REF BOUNDED: ( a +=: b ), # PRUS #
    MINUSAB = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a *:= b ),
    DIVAB   = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a /:= b ),
    OVERAB  = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a %:= b ),
    MODAB   = (REF BOUNDED a, BOUNDED b)REF BOUNDED: ( a %*:= b );

END COMMENT
Test:
 RANGE range = RANGE(0, 10000);

 # override the default exception #
 raise bounds error := ([]STRING args)VOID: (
     putf(stand error, ($g$, args, $"- exiting to except bounds error"l$));
     except bounds error
   );

 BOUNDED a, b := 0 OVER range;
 FOR step FROM 4 BY 4 TO UPB range DO # something for pythagoras #
   b := b + step OVER range;
   a := ENTIER sqrt( 1.5 + 2 * value OF b ) OVER range OF b;
   printf(($"Sum of "$, bounded repr, a * a, b * b,
           $" is "$,    bounded repr, a * a + b * b, $l$))
 OD;
 except bounds error:
   SKIP
