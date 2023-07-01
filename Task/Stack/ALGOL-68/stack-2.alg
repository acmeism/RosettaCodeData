# -*- coding: utf-8 -*- #
CO REQUIRES:
  MODE OBJNEXTLINK = STRUCT(
    REF OBJNEXTLINK next,
    OBJVALUE value
  );
  PROC obj nextlink new = REF OBJNEXTLINK: ~,
  PROC obj nextlink free = (REF OBJNEXTLINK free)VOID: ~
END CO

# actually a pointer to the last LINK, there ITEMs are ADDED, pushed & popped #
MODE OBJSTACK = REF OBJNEXTLINK;

OBJSTACK obj stack empty = NIL;

BOOL obj stack par = FALSE; # make code thread safe #
SEMA obj stack sema = LEVEL ABS obj stack par;
# Warning: 1 SEMA for all stacks of type obj, i.e. not 1 SEMA per stack #

PROC obj stack init = (REF OBJSTACK self)REF OBJSTACK:
  self := obj stack empty;

# see if the program/coder wants the OBJ problem mended... #
PROC (REF OBJSTACK #self#)BOOL obj stack index error mended
  := (REF OBJSTACK self)BOOL: (abend("obj stack index error"); stop);

PROC on obj stack index error = (REF OBJSTACK self, PROC(REF OBJSTACK #self#)BOOL mended)VOID:
  obj stack index error mended := mended;

PROC obj stack push = (REF OBJSTACK self, OBJVALUE obj)REF OBJSTACK:(
  IF obj stack par THEN DOWN obj stack sema FI;
  self := obj nextlink new := (self, obj);
  IF obj stack par THEN UP obj stack sema FI;
  self
);

# aliases: define a useful put (+=:) operator... #
OP +=: = (OBJVALUE obj, REF OBJSTACK self)REF OBJSTACK: obj stack push(self, obj);

PROC obj stack pop = (REF OBJSTACK self)OBJVALUE: (
# DOWN obj stack sema; #
  IF self IS obj stack empty THEN
    IF NOT obj stack index error mended(self) THEN abend("obj stack index error") FI FI;

  OBJNEXTLINK old head := self;
  OBJSTACK new head := next OF self;
  OBJVALUE out := value OF old head;
  obj nextlink free(old head); # freeing nextlink, NOT queue! #
  self := new head;
#;UP obj stack sema; #
  out
);

PROC obj stack is empty = (REF OBJSTACK self)BOOL:
  self IS obj stack empty;

SKIP
