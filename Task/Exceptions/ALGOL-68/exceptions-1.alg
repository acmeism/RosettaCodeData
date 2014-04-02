# a user defined object #
MODE FOO = STRUCT ( ... )
  FOOOBJECTNEW = STRUCT (FOOMEND foo exception x mended, FOO instance),
  FOOOBJECT = REF FOOOBJECTNEW,
  FOOMEND = PROC (FOOOBJECT)BOOL;

PROC on foo exception x = (FOOOBJECT foo, PROC (FOOOBJECT)BOOL foo exception x mend)VOID: (
  foo exception x mended OF foo := foo exception x mend
);
