# -*- coding: utf-8 -*- #
CO REQUIRES:
  MODE OBJVALUE = ~ # Mode/type of actual obj to be stacked #
END CO

MODE OBJNEXTLINK = STRUCT(
  REF OBJNEXTLINK next,
  OBJVALUE value # ... etc. required #
);

PROC obj nextlink new = REF OBJNEXTLINK:
  HEAP OBJNEXTLINK;

PROC obj nextlink free = (REF OBJNEXTLINK free)VOID:
  next OF free := obj stack empty # give the garbage collector a BIG hint #
