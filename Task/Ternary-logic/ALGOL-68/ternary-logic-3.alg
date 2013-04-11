#!/usr/local/bin/a68g --script #
# -*- coding: utf-8 -*- #

PR READ "prelude/general.a68" PR
PR READ "Ternary_logic.a68" PR

[]TRIT trits = (false, maybe, true);

FORMAT
  col fmt = $" "g" "$,
  row fmt = $l3(f(col fmt)"|")f(col fmt)$,
  row sep fmt = $l3("---+")"---"l$;

PROC row sep = VOID:
  printf(row sep fmt);

PROC title = (STRING op name, LONGCHAR op char)VOID:(
  print(("Operator: ",op name));
  printf((row fmt,op char,REPR false, REPR maybe, REPR true))
);

PROC print trit op table = (LONGCHAR op char, STRING op name, PROC(TRIT,TRIT)TRIT op)VOID: (
  printf($l$);
  title(op name, op char);
  FOR i FROM LWB trits TO UPB trits DO
    row sep;
    TRIT ti = trits[i];
    printf((col fmt, REPR ti));
    FOR j FROM LWB trits TO UPB trits DO
      TRIT tj = trits[j];
      printf(($"|"$, col fmt, REPR op(ti,tj)))
    OD
  OD;
  printf($l$)
);

printf((
  $"Comparitive table of coercions:"l$,
  $"  TRIT BOOL         INT"l$
));

FOR it FROM LWB trits TO UPB trits DO
  TRIT t = trits[it];
  printf(( $"  "g"  "$, REPR t,
    IF trit OF t = trit OF maybe THEN " " ELSE B t FI,
    INITINT t, $l$))
OD;

printf((
  $l"Specific test of the IMPLIES operator:"l$,
  $"  "g" implies "g" is "b("not ","")"a contradiction!"l$,
    B false,    B false,    B(false IMPLIES false),
    B false,    B true,     B(false IMPLIES true),
    B false,    REPR maybe, B(false IMPLIES maybe),
    B true,     B false,    B(true  IMPLIES false),
    B true,     B true,     B(true  IMPLIES true),
    REPR maybe, Btrue,      B(maybe IMPLIES true),
  $"  "g" implies "g" is "g" a contradiction!"l$,
    B true,     REPR maybe, REPR (true  IMPLIES maybe),
    REPR maybe, B false,    REPR (maybe IMPLIES false),
    REPR maybe, REPR maybe, REPR (maybe IMPLIES maybe),
  $l$
));

printf($"Kleene logic truth table samples:"l$);

print trit op table("≡","EQV",     (TRIT a,b)TRIT: a EQV b);
print trit op table("⊃","IMPLIES", (TRIT a,b)TRIT: a IMPLIES b);
print trit op table("∧","AND",     (TRIT a,b)TRIT: a AND b);
print trit op table("∨","OR",      (TRIT a,b)TRIT: a OR b)
