# -*- coding: utf-8 -*- #
CO REQUIRES:
  MODE OBJVALUE = ~ # Mode/type of actual obj to be queued #
END CO

MODE OBJLINK = STRUCT(
  REF OBJLINK next,
  REF OBJLINK prev,
  OBJVALUE value # ... etc. required #
);

PROC obj link new = REF OBJLINK: HEAP OBJLINK;

PROC obj link free = (REF OBJLINK free)VOID:
   prev OF free := next OF free := obj queue empty # give the garbage collector a big hint #
