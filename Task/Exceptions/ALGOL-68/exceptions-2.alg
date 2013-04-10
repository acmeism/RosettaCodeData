OBJECTFOO foo proxy := foo base; # event routines are specific to an foo #

on foo event(foo proxy, raise foo event);

WHILE TRUE DO
  # now raise example foo event #
  IF NOT (foo event mended OF foo proxy)(foo proxy) THEN undefined # trace back # FI
OD;
