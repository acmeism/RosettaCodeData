FOOOBJECTNEW foo instance := foo base; # exception x routines are specific to a foo #

FOOMEND prior foo exception x mend = foo exception x mended OF foo;
on foo exception x(foo instance, raise foo exception x);

WHILE TRUE DO
  # now manually raise example "foo exception x" #
  raise foo exception x(foo instance)
OD;
