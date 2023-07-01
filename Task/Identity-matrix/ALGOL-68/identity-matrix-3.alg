# -*- coding: utf-8 -*- #

PRIO IDENT = 9; # The same as I for COMPLex #

OP IDENT = (INT lwb, upb)MATNEW:
  ONEINIT LOC [lwb:upb,lwb:upb]SCAL;

OP IDENT = (INT upb)MATNEW: # default lwb is 1 #
  1 IDENT upb;

SKIP
