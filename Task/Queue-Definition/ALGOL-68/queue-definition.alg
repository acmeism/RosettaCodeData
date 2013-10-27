# -*- coding: utf-8 -*- #
CO REQUIRES:
  MODE OBJLINK = STRUCT(
    REF OBJLINK next,
    REF OBJLINK prev,
    OBJVALUE value # ... etc. required #
  );
  PROC obj link new = REF OBJLINK: ~;
  PROC obj link free = (REF OBJLINK free)VOID: ~
END CO

# actually a pointer to the last LINK, there ITEMs are ADDED/get #
MODE OBJQUEUE = REF OBJLINK;

OBJQUEUE obj queue empty = NIL;

BOOL obj queue par = FALSE; # make code thread safe #
SEMA obj queue sema = LEVEL ABS obj queue par;
# Warning: 1 SEMA for all queues of type obj, i.e. not 1 SEMA per queue #

PROC obj queue init = (REF OBJQUEUE self)REF OBJQUEUE:
  self := obj queue empty;

PROC obj queue put = (REF OBJQUEUE self, OBJVALUE obj)REF OBJQUEUE: (
  REF OBJLINK out = obj link new;
  IF obj queue par THEN DOWN obj queue sema FI;
  IF self IS obj queue empty THEN
    out := (out, out, obj) # self referal #
  ELSE # join into list #
    out := (self, prev OF self, obj);
    next OF prev OF out := prev OF next OF out := out
  FI;
  IF obj queue par THEN UP obj queue sema FI;
  self := out
);

# define a useful prepend/put/plusto (+=:) operator... #
PROC obj queue plusto = (OBJVALUE obj, REF OBJQUEUE self)OBJQUEUE: obj queue put(self,obj);
OP +=: = (OBJVALUE obj, REF OBJQUEUE self)REF OBJQUEUE: obj queue put(self,obj);
# a potential append/plusab (+:=) operator...
OP (REF OBJQUEUE, OBJVALUE)OBJQUEUE +:= = obj queue plusab;
#

# see if the program/coder wants the OBJ problem mended... #
PROC (REF OBJQUEUE #self#)BOOL obj queue index error mended
  := (REF OBJQUEUE self)BOOL: (abend("obj queue index error"); stop);

PROC on obj queue index error = (REF OBJQUEUE self, PROC(REF OBJQUEUE #self#)BOOL mended)VOID:
  obj queue index error mended := mended;

PROC obj queue get = (REF OBJQUEUE self)OBJVALUE: (
# DOWN obj queue sema; #
  IF self IS obj queue empty THEN
    IF NOT obj queue index error mended(self) THEN abend("obj stack index error") FI FI;
  OBJQUEUE old tail = prev OF self;
  IF old tail IS self THEN # free solo member #
    self := obj queue empty
  ELSE # free self/tail member #
    OBJQUEUE new tail = prev OF old tail;
    next OF new tail := self;
    prev OF self := new tail
  FI;
#;UP obj queue sema #
  OBJVALUE out = value OF old tail;
# give a recovery hint to the garbage collector #
  obj link free(old tail);
  out
);

PROC obj queue is empty = (REF OBJQUEUE self)BOOL:
  self IS obj queue empty;

SKIP
