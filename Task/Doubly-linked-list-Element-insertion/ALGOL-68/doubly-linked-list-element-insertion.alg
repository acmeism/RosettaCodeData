#!/usr/local/bin/a68g --script #

# SEMA do link OF splice = LEVEL 1 #
MODE LINK = STRUCT (
  REF LINK prev,
  REF LINK next,
  DATA value
);

# BEGIN rosettacode task specimen code:
  can handle insert both before the first, and after the last link #

PROC insert after = (REF LINK #self,# prev, DATA new data)LINK: (
# DOWN do link OF splice OF self; to make thread safe #
  REF LINK next = next OF prev;
  HEAP LINK new link := LINK(prev, next, new data);
  next OF prev := prev OF next := new link;
# UP do link OF splice OF self; #
  new link
);

PROC insert before = (REF LINK #self,# next, DATA new data)LINK:
  insert after(#self,# prev OF next, new data);

# END rosettacode task specimen code #

# Test case: #
MODE DATA = STRUCT(INT year elected, STRING name);
FORMAT data fmt = $dddd": "g"; "$;

test:(

# manually initialise the back splices #
  LINK presidential splice;
  presidential splice := (presidential splice, presidential splice, SKIP);

# manually build the chain #
  LINK previous, incumbent, elect;
  previous := (presidential splice, incumbent,          DATA(1993, "Clinton"));
  incumbent:= (previous,           elect,              DATA(2001, "Bush"   ));
  elect    := (incumbent,          presidential splice, DATA(2008, "Obama"  ));

  insert after(incumbent, LOC DATA := DATA(2004, "Cheney"));

  REF LINK node := previous;
  WHILE REF LINK(node) ISNT presidential splice DO
    printf((data fmt, value OF node));
    node := next OF node
  OD;
  print(new line)
)
