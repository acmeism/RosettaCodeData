$$ MODE TUSCRIPT
SET haystack="Zig'Zag'Wally'Ronald'Bush'Krusty'Charlie'Bush'Bozo"
PRINT "haystack=",haystack
LOOP needle="Washington'Bush'Wally"
SET table  =QUOTES (needle)
BUILD S_TABLE needle = table
 IF (haystack.ct.needle) THEN
  BUILD R_TABLE needle = table
  SET position=FILTER_INDEX(haystack,needle,-)
  RELEASE R_TABLE needle
  PRINT "haystack contains ", needle, " on position(s): ",position
 ELSE
  PRINT "haystack not contains ",needle
 ENDIF
RELEASE S_TABLE needle
ENDLOOP
