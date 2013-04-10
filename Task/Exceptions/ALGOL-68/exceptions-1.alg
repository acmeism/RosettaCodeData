# a user defined object #
MODE OBJECTFOO = STRUCT ( PROC (REF OBJECTFOO)BOOL foo event mended, ... );

PROC on foo event = (REF OBJECTFOO foo, PROC (REF OBJECTFOO)BOOL foo event)VOID: (
  foo event mended OF foo := foo event
);
