# Utilities code #

CHAR dir sep = "/"; # Assume POSIX #

PROC dir name = (STRING dir)STRING: (
  STRING out;
  FOR pos FROM UPB dir BY -1 TO LWB dir DO
    IF dir[pos] = dir sep THEN
      out := dir[:pos-1];
      GO TO out exit
    FI
  OD;
  # else: # out:="";
  out exit: out
);

PROC shortest = ([]STRING string list)STRING: (
  INT min := max int;
  INT min key := LWB string list - 1;
  FOR key FROM LWB string list TO UPB string list DO
    IF UPB string list[key][@1] < min THEN
      min := UPB string list[key][@1];
      min key := key
    FI
  OD;
  string list[min key]
);

# Actual code #

PROC common prefix = ([]STRING strings)STRING: (
  IF LWB strings EQ UPB strings THEN
    # exit: # strings[LWB strings]
  ELSE
    STRING prefix := shortest(strings);
    FOR pos FROM LWB prefix TO UPB prefix DO
      CHAR first = prefix[pos];
      FOR key FROM LWB strings+1 TO UPB strings DO
        IF strings[key][@1][pos] NE first THEN
          prefix := prefix[:pos-1];
          GO TO prefix exit
        FI
      OD
    OD;
    prefix exit: prefix
  FI
);

# Test code #

test:(
  []STRING dir list = (
    "/home/user1/tmp/coverage/test",
    "/home/user1/tmp/covert/operator",
    "/home/user1/tmp/coven/members"
  );
  print((dir name(common prefix(dir list)), new line))
)
