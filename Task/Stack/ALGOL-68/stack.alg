MODE VALUE = STRING; # type of a LINK in this STACK #

MODE LINK = STRUCT(VALUE value, REF LINK next);
MODE STACK = STRUCT(REF LINK first);

STRUCT (
    PROC (REF STACK)VOID init,
    PROC (REF STACK)BOOL non zero,
    PROC (REF STACK, VALUE)VOID append,
    PROC (REF STACK)VALUE pop,
    PROC (REF STACK)STRING repr,
    PROC (REF STACK, STRING)BOOL index error mended
) class stack = (
  # PROC init = # (REF STACK self)VOID:
        first OF self := NIL,
  # PROC non zero = # (REF STACK self)BOOL:
        REF LINK(first OF self) ISNT NIL ,
  # PROC append = # (REF STACK self, VALUE value)VOID:
        first OF self := HEAP LINK := (value, first OF self),
  # PROC pop = # (REF STACK self)VALUE: (
        IF first OF self IS NIL THEN
            STRING message = "pop from empty stack";
            IF NOT (index error mended OF class stack)(self, message) THEN
                raise index error(message)
            FI
        FI;
        VALUE out = value OF first OF self;
        first OF self := next OF first OF self;
        out
    ),
  # PROC repr = # (REF STACK self)STRING: (
        STRING out := "(",
               sep := "";
        REF LINK this := first OF self;
        WHILE REF LINK(this) ISNT NIL DO
          out +:= sep + """" + value OF this + """";
          sep := ", ";
          this := next OF this
        OD;
        out+")"
    ),
  # PROC index error mended = # (REF STACK self, STRING message)BOOL:
        FALSE # no mend applied #
);

PROC raise index error := (STRING message)VOID: stop;

STACK stack;  (init OF class stack)(stack);

[]STRING sample = ("Was", "it", "a", "cat", "I", "saw");

FOR i TO UPB sample DO
  (append OF class stack)(stack, sample[i])
OD;

print(((repr OF class stack)(stack), newline))
