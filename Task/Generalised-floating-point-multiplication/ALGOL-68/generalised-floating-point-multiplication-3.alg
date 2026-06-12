#!/usr/local/bin/a68g --script #
####################################################################
# A program to test arbitrary length floating point multiplication #
####################################################################

PR READ "prelude/general.a68" PR  # [[rc:Template:ALGOL 68/prelude]] #

PR READ "Template.Big_float.Multiplication.a68" PR

# include the basic axioms of the digits being used #
PR READ "Template.Balanced_ternary_float.Base.a68" PR

PR READ "Template.Big_float.Addition.a68" PR # [[rc:Generalised floating point addition]] #
PR READ "Template.Big_float.Subtraction.a68" PR # [[rc:Generalised floating point addition]] #

test1:( # Basic arithmetic #
  INT rw = long real width;
  BIGREAL a = INITBIGREAL "+-0++0+.+-0++0+", # 523.239... #
          b = INITBIGREAL - LONG 436.436,
          c = INITBIGREAL "+-++-.+-++-"; # 65.267... #
  printf(($g 9k g(rw,rw-5)39kgl$,
    "a =",INITLONGREAL a, REPR a,
    "b =",INITLONGREAL b, REPR b,
    "c =",INITLONGREAL c, REPR c,
    "a*(b-c)",INITLONGREAL(a*(b-c)), REPR(a*(b-c)),
  $l$))
);

test2:( # A floating point Ternary multiplication table #
  FORMAT s = $"|"$; # field seperator #

  INT lwb = 1, tab = 8, upb = 12;

  printf($"# "f(s)" *   "f(s)$);
  FOR j FROM lwb TO upb DO
    FORMAT col = $n(tab)k f(s)$;
    printf(($g" #"g(0)f(col)$, REPR INITBIGREAL j,j))
  OD;
  printf($l$);
  FOR i FROM lwb TO 27 DO
    printf(($g(0) 3k f(s) g 9k f(s)$,i,REPR INITBIGREAL i));
    FOR j FROM lwb TO i MIN upb DO
      FORMAT col = $n(tab)k f(s)$;
      BIGREAL product = INITBIGREAL i * INITBIGREAL j;
      printf(($gf(col)$, REPR product))
    OD;
    IF upb > i THEN printf($n(upb-i)(n(tab-1)x f(s))$) FI;
    printf($l$)
  OD
)
