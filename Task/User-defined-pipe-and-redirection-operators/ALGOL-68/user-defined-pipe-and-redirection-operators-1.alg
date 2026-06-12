MODE
  PAGEIN =         PAGE,
  PAGEAPPEND = REF PAGE,
  PAGEOUT =    REF PAGE;

MODE
  MOID = VOID,
  YIELDLINE = PROC(LINE)VOID,
  GENLINE = PROC(YIELDLINE)VOID,
  FILTER = PROC(GENLINE)GENLINE, # the classic shell filter #
  MANYTOONE = PROC([]GENLINE)GENLINE; # eg cat, as in con[cat]enate #

PRIO =: = 5, << = 5, >> = 5;

OP <  = (FILTER filter, PAGEIN page)GENLINE: filter(READ page),
   <  = (MANYTOONE cmd, PAGEIN page)GENLINE: cmd(READ page),
   << = (FILTER filter, PAGEIN page)GENLINE: filter(READ page),
   >  = (GENLINE gen, PAGEOUT page)VOID: gen(WRITE page),
   >> = (GENLINE gen, PAGEAPPEND page)VOID: gen(APPEND page),
   =: = (GENLINE gen, FILTER filter)GENLINE: filter(gen),
   =: = (GENLINE gen, MANYTOONE cmd)GENLINE: cmd(gen);
