MODE LINK = STRUCT (
  REF LINK prev,
  REF LINK next,
  DATA value
);

MODE DATA = STRUCT(INT year elected, STRING name);

LINK previous, incumbent, elect;
previous := (NIL, incumbent, DATA(1993, "Clinton"));
incumbent:= (previous, elect,DATA(2001, "Bush"   ));
elect    := (incumbent, NIL, DATA(2008, "Obama"  ));

REF LINK node := previous;
WHILE REF LINK(node) ISNT NIL DO
  printf(($dddd": "g"; "$,value OF node));
  node := next OF node
OD;
print(new line);

node := elect;
WHILE REF LINK(node) ISNT NIL DO
  printf(($dddd": "g"; "$,value OF node));
  node := prev OF node
OD;
print((newline))
