#!/usr/bin/a68g --script #
# -*- coding: utf-8 -*- #

REAL desired probability := 0.5; # 50% #

REAL upb year = 365 + 1/4 # - 3/400 but alive, ignore those born prior to 1901 #,
INT upb sample size = 100 000,
    upb common = 5 ;

FORMAT name int fmt = $g": "g(-0)"; "$,
       name real fmt = $g": "g(-0,4)"; "$,
       name percent fmt = $g": "g(-0,2)"%; "$;

printf((
  name real fmt,
  "upb year",upb year,
  name int fmt,
  "upb common",upb common,
  "upb sample size",upb sample size,
  $l$
));

INT required common := 1; # initial value #
FOR group size FROM required common WHILE required common <= upb common DO
  INT sample with no required common := 0;
  TO upb sample size DO
  # generate sample #
    [group size]INT sample;
    FOR i TO UPB sample DO sample[i] := ENTIER(random * upb year) + 1 OD;
    FOR birthday i TO UPB sample DO
      INT birthday = sample[birthday i];
      INT number in common := 1;
    # special case = 1 #
      IF number in common >= required common THEN
        found required common
      FI;
      FOR birthday j FROM birthday i + 1 TO UPB sample DO
        IF birthday = sample[birthday j] THEN
          number in common +:= 1;
          IF number in common >= required common THEN
            found required common
          FI
        FI
      OD
    OD  # days in year #;
    sample with no required common +:= 1;
    found required common: SKIP
  OD # sample size #;
  REAL portion of years with required common birthdays =
    (upb sample size - sample with no required common) / upb sample size;
  print(".");
  IF portion of years with required common birthdays > desired probability THEN
    printf((
      $l$,
      name int fmt,
      "required common",required common,
      "group size",group size,
      # "sample with no required common",sample with no required common, #
      name percent fmt,
      "%age of years with required common birthdays",portion of years with required common birthdays*100,
      $l$
    ));
    required common +:= 1
  FI
OD # group size #
