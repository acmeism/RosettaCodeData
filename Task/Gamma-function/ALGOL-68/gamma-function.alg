# Coefficients used by the GNU Scientific Library #
[]LONG REAL p = ( LONG    0.99999 99999 99809 93,
                  LONG  676.52036 81218 851,
                 -LONG 1259.13921 67224 028,
                  LONG  771.32342 87776 5313,
                 -LONG  176.61502 91621 4059,
                  LONG   12.50734 32786 86905,
                 -LONG    0.13857 10952 65720 12,
                  LONG    9.98436 95780 19571 6e-6,
                  LONG    1.50563 27351 49311 6e-7);

PROC lanczos gamma = (LONG REAL in z)LONG REAL: (
  # Reflection formula #
  LONG REAL z := in z;
  IF z < LONG 0.5 THEN
    long pi / (long sin(long pi*z)*lanczos gamma(1-z))
  ELSE
    z -:= 1;
    LONG REAL x := p[1];
    FOR i TO UPB p - 1 DO x +:= p[i+1]/(z+i) OD;
    LONG REAL t = z + UPB p - LONG 1.5;
    long sqrt(2*long pi) * t**(z+LONG 0.5) * long exp(-t) * x
  FI
);

PROC taylor gamma = (LONG REAL x)LONG REAL:
BEGIN # good for values between 0 and 1 #
    []LONG REAL a =
        ( LONG 1.00000 00000 00000 00000,
          LONG 0.57721 56649 01532 86061,
         -LONG 0.65587 80715 20253 88108,
         -LONG 0.04200 26350 34095 23553,
          LONG 0.16653 86113 82291 48950,
         -LONG 0.04219 77345 55544 33675,
         -LONG 0.00962 19715 27876 97356,
          LONG 0.00721 89432 46663 09954,
         -LONG 0.00116 51675 91859 06511,
         -LONG 0.00021 52416 74114 95097,
          LONG 0.00012 80502 82388 11619,
         -LONG 0.00002 01348 54780 78824,
         -LONG 0.00000 12504 93482 14267,
          LONG 0.00000 11330 27231 98170,
         -LONG 0.00000 02056 33841 69776,
          LONG 0.00000 00061 16095 10448,
          LONG 0.00000 00050 02007 64447,
         -LONG 0.00000 00011 81274 57049,
          LONG 0.00000 00001 04342 67117,
          LONG 0.00000 00000 07782 26344,
         -LONG 0.00000 00000 03696 80562,
          LONG 0.00000 00000 00510 03703,
         -LONG 0.00000 00000 00020 58326,
         -LONG 0.00000 00000 00005 34812,
          LONG 0.00000 00000 00001 22678,
         -LONG 0.00000 00000 00000 11813,
          LONG 0.00000 00000 00000 00119,
          LONG 0.00000 00000 00000 00141,
         -LONG 0.00000 00000 00000 00023,
          LONG 0.00000 00000 00000 00002
        );
    LONG REAL y = x - 1;
    LONG REAL sum := a [UPB a];
    FOR n FROM UPB a - 1 DOWNTO LWB a DO
       sum := sum * y + a [n]
    OD;
    1/sum
END # taylor gamma #;

LONG REAL long e = long exp(1);

PROC sterling gamma = (LONG REAL n)LONG REAL:
( # improves for values much greater then 1 #
  long sqrt(2*long pi/n)*(n/long e)**n
);

PROC factorial = (LONG INT n)LONG REAL:
(
  IF n=0 OR n=1 THEN 1
  ELIF n=2 THEN 2
  ELSE n*factorial(n-1) FI
);

REF[]LONG REAL fm := NIL;

PROC sponge gamma = (LONG REAL x)LONG REAL:
(
  INT a = 12; # alter to get required precision #
  REF []LONG REAL fm := NIL;
  LONG REAL res;

  IF fm :=: REF[]LONG REAL(NIL) THEN
    fm := HEAP[0:a-1]LONG REAL;
    fm[0] := long sqrt(LONG 2*long pi);
    FOR k TO a-1 DO
      fm[k] := (((k-1) MOD 2=0) | 1 | -1) * long exp(a-k) *
	(a-k) **(k-LONG 0.5) / factorial(k-1)
    OD
  FI;
  res := fm[0];
  FOR k TO a-1 DO
    res +:= fm[k] / ( x + k )
  OD;
  res *:= long exp(-(x+a)) * (x+a)**(x + LONG 0.5);
  res/x
);

FORMAT real fmt = $g(-real width, real width - 2)$;
FORMAT long real fmt16 = $g(-17, 17 - 2)$; # accurate to about 16 decimal places #

[]STRING methods = ("Genie", "Lanczos", "Sponge", "Taylor","Stirling");

printf(($11xg12xg12xg13xg13xgl$,methods));

FORMAT sample fmt = $"gamma("g(-3,1)")="f(real fmt)n(UPB methods-1)(", "f(long real fmt16))l$;
FORMAT sqr sample fmt = $"gamma("g(-3,1)")**2="f(real fmt)n(UPB methods-1)(", "f(long real fmt16))l$;
FORMAT sample exp fmt = $"gamma("g(-3)")="g(-15,11,0)n(UPB methods-1)(","g(-18,14,0))l$;

PROC sample = (LONG REAL x)[]LONG REAL:
  (gamma(SHORTEN x), lanczos gamma(x), sponge gamma(x), taylor gamma(x), sterling gamma(x));

FOR i FROM 1 TO 20 DO
  LONG REAL x = i / LONG 10;
  printf((sample fmt, x, sample(x)));
  IF i = 5 THEN # insert special case of a half #
    printf((sqr sample fmt,
            x, gamma(SHORTEN x)**2,  lanczos gamma(x)**2, sponge gamma(x)**2,
            taylor gamma(x)**2, sterling gamma(x)**2))
  FI
OD;
FOR x FROM 10 BY 10 TO 70 DO
  printf((sample exp fmt, x, sample(x)))
OD
