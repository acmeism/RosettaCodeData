#!/usr/local/bin/a68g --script #

PRIO MIN=5, MAX=5;
OP MIN = (INT a, b)INT: (a<b|a|b),
   MAX = (INT a, b)INT: (a>b|a|b);

MODE STRADDLINGCHECKERBOARD=STRUCT(
  [0:9]CHAR first, second, third,
  [ABS ".": ABS "Z"]STRING table,
  INT row u, row v,
  CHAR esc, skip
);

STRUCT(
  PROC (REF STRADDLINGCHECKERBOARD #self#, STRING #alphabet#, INT #u#, INT #v#)VOID init,
  PROC (REF STRADDLINGCHECKERBOARD #self#, STRING #plain#)STRING encode,
  PROC (REF STRADDLINGCHECKERBOARD #self#, STRING #plain#)STRING decode
) sc class = (
# PROC init = # (REF STRADDLINGCHECKERBOARD self, STRING in alphabet, INT u, v)VOID:
  (
    STRING alphabet = in alphabet[@0];

    esc OF self := alphabet[UPB alphabet]; # use the last CHAR as the escape #
    skip OF self := alphabet[UPB alphabet-1];

    row u OF self := u MIN v;
    row v OF self := u MAX v;

    OP DIGIT = (INT i)CHAR: REPR(ABS "0" + i );

    INT j := LWB alphabet;

  # (first OF self)[u] := (first OF self)[v] := skip; #

    FOR i FROM LWB first OF self TO UPB first OF self  DO
      IF i NE u AND i NE v THEN
        (first OF self)[i] := alphabet[j];
        (table OF self)[ABS alphabet[j]] := DIGIT i;
        j+:=1
      FI;

      (second OF self)[i] := alphabet[i+8];
      (table OF self)[ABS alphabet[i+8]] := DIGIT (row u OF self) + DIGIT i;

      (third OF self)[i] := alphabet[i+18];
      (table OF self)[ABS alphabet[i+18]] := DIGIT (row v OF self) + DIGIT i
    OD
  ),

# PROC encode = # (REF STRADDLINGCHECKERBOARD self, STRING plain)STRING:
  (
    STRING esc = (table OF self)[ABS (esc OF self)];
    INT l2u = ABS "A" - ABS "a";

    STRING out := "";
    FOR i FROM LWB plain TO UPB plain DO
      CHAR c := plain[i];
      IF "a" <= c AND c <= "z" THEN
        c := REPR ( ABS c + l2u) FI;

      IF "A" <= c AND c <= "Z" THEN
        out +:= (table OF self)[ABS c]
      ELIF "0" <= c AND c <= "9" THEN
        out +:= esc + c
      FI
    OD;
    out # EXIT #
  ),

# PROC decode = # (REF STRADDLINGCHECKERBOARD self, STRING cipher)STRING:
  (
    CHAR null = REPR 0;
    STRING out;
    INT state := 0;
    FOR i FROM LWB cipher TO UPB cipher DO
      INT n := ABS cipher[i] - ABS "0";

      CHAR next :=
        CASE state IN
          #1:# (second OF self)[n],
          #2:# (third OF self)[n],
          #3:# cipher[i]
        OUT
          IF n = row u OF self THEN
            state := 1; null
          ELIF n = row v OF self THEN
            state := 2; null
          ELSE
            (first OF self)[n]
          FI
        ESAC;

      IF next = "/" THEN
        state := 3
      ELIF next NE null THEN
        state := 0;
        out +:= next
      FI
    OD;
    out # EXIT #
  )
);

main:
(
  STRADDLINGCHECKERBOARD sc; (init OF sc class)(sc, "HOLMESRTABCDFGIJKNPQUVWXYZ./", 3, 7);

  STRING original := "One night-it was on the twentieth of March, 1888-I was returning"[@0];
  STRING en := (encode OF sc class)(sc, original);
  STRING de := (decode OF sc class)(sc, en);

  printf(($ggl$,
          "Original: ", original,
          "Encoded:  ", en,
          "Decoded:  ", de
  ))

)
