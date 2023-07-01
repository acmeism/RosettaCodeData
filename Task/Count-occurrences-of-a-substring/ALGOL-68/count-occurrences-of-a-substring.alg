#!/usr/local/bin/a68g --script #

PROC count string in string = (STRING needle, haystack)INT: (
  INT start:=LWB haystack, next, out:=0;
  FOR count WHILE string in string(needle, next, haystack[start:]) DO
    start+:=next+UPB needle-LWB needle;
    out:=count
  OD;
  out
);

printf(($d" "$,
  count string in string("th", "the three truths"),    # expect 3 #
  count string in string("abab", "ababababab"),        # expect 2 #
  count string in string("a*b", "abaabba*bbaba*bbab"), # expect 2 #
  $l$
))
