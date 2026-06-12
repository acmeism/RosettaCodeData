#!/usr/local/bin/a68g --script #

MODE LBITS = LONG BITS;
PR READ "Template.Find_first_and_last_set_bit.a68" PR

INT bits of prod;
FORMAT header fmt = $g 36k"|RLWB|RUPB|Bits"l$;
FORMAT row fmt0 = $g(-35)"|"2(g(-3)" |"),2rd l$;
FORMAT row fmt  = $g(-35)"|"2(g(-3)" |"),2rn(bits of prod+1)d l$;

test int:(
  printf((header fmt, "INT: find first & last set bit"));
  INT prod := 0;

  # test case 0 #
  prod := 0; bits of prod := RUPB BIN prod;
  printf((row fmt0, prod, RLWB BIN prod, RUPB BIN prod, BIN prod));

  prod := 1; # test case 1 etc ... #
  INT zoom := 2 * 3 * 7;
  WHILE
    bits of prod := RUPB BIN prod;
    printf((row fmt, prod, RLWB BIN prod, RUPB BIN prod, BIN prod));
# WHILE # prod <=      max int / zoom DO
    prod *:= zoom
  OD
);

test long int:(
  printf(($l$,header fmt, "LONG INT:"));
  LONG INT prod := 0;

  # test case 0 #
  prod := 0; bits of prod := RUPB BIN prod;
  printf((row fmt0, prod, RLWB BIN prod, RUPB BIN prod, BIN prod));

  prod := 1; # test case 1 etc ... #
  INT zoom := 2 * 3 * 7 * 31;
  WHILE
    bits of prod := RUPB BIN prod;
    printf((row fmt, prod, RLWB BIN prod, RUPB BIN prod, BIN prod));
# WHILE # prod <= long max int / zoom DO
    prod *:= zoom
  OD
)
