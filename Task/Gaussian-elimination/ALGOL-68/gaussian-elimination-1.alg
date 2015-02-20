# -*- coding: utf-8 -*- #
COMMENT PROVIDES
  MODE FIXED; INT fixed exception, unfixed exception;
  PROC (STRING message) FIXED raise, raise value error
END COMMENT

# Note: ℵ indicates attribute is "private", and
        should not be used outside of this prelude #

MODE FIXED = BOOL; # if an exception is detected, can it be fixed "on-site"? #
FIXED fixed exception = TRUE, unfixed exception = FALSE;

MODE #ℵ#SIMPLEOUTV = [0]UNION(CHAR, STRING, INT, REAL, BOOL, BITS);
MODE #ℵ#SIMPLEOUTM = [0]#ℵ#SIMPLEOUTV;
MODE #ℵ#SIMPLEOUTT = [0]#ℵ#SIMPLEOUTM;
MODE SIMPLEOUT  = [0]#ℵ#SIMPLEOUTT;

PROC raise = (#ℵ#SIMPLEOUT message)FIXED: (
  putf(stand error, ($"Exception:"$, $xg$, message, $l$));
  stop
);

PROC raise value error = (#ℵ#SIMPLEOUT message)FIXED:
  IF raise(message) NE fixed exception THEN exception value error; FALSE FI;

SKIP
