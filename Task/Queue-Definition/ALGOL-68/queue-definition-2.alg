  MODE OBJLINK = STRUCT(
    REF OBJLINK next,
    REF OBJLINK prev,
    OBJVALUE value # ... etc. required #
  );
  PROC obj link new = REF OBJLINK: HEAP OBJLINK;
  PROC obj link free = (REF OBJLINK free)VOID: SKIP
