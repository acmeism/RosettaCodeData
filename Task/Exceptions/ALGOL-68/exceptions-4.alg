   on foo exception x(foo instance, prior foo exception x mend);
... EXIT
except foo exception x:
  SKIP # exception x caught code here ... #
# to continue to propagate an exception x is a bit more problematic...#
# and requires nesting/restoring prior "raise foo exception x"#
   on foo exception x(foo instance, prior foo exception x mend);
   raise foo exception x(foo instance)
