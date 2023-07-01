# -*- coding: utf-8 -*- #
MODE LISTNEW = LINKNEW;
MODE LIST = REF LISTNEW;

OP LISTINIT = (LIST self)LIST: (
  self := (self, self, ~);
  self
);

OP ISEMPTY = (LIST self)BOOL:
  (LIST(prev OF self) :=: LIST(self)) AND (LIST(self) :=: LIST(next OF self));

OP HEAD = (LIST self)LINK: next OF self;

OP TAIL = (LIST self)LINK: prev OF self;

# insert after #
OP +:= = (LINK cursor, LINK link)LINK: (
  next OF link := next OF cursor;
  prev OF link := cursor;
  next OF cursor := link;
  prev OF next OF link := link;
  link
);

# insert before #
OP +=: = (LINK link, LINK cursor)LINK: prev OF cursor +:= link;

# delete current and step forward #
OP -:= = (LIST ignore, LINK link)LINK: (
  next OF prev OF link := next OF link;
  prev OF next OF link := prev OF link;
  next OF link := prev OF link := NIL; # garbage collection hint #
  link
);

# delete current and step backward #
PRIO -=: = 1;
OP -=: = (LIST link, LIST ignore)LINK: (
  ignore -:= link; prev OF link
);

PRIO ISIN = 1; # low priority #

OP ISIN = (LINK link, LIST self)BOOL:
  link ISNT LINK(self);

SKIP
