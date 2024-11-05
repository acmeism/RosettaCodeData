PROC count string in string = (STRING needle, haystack)INT: (
  INT start pos:=LWB haystack, next, out:=0;
  FOR count WHILE string in string(needle, next, haystack[start pos:]) DO
    start pos+:=next+UPB needle-LWB needle;
    out:=count
  OD;
  out
);

print((
  whole( count string in string("th", "the three truths"), 0 )    # expect 3 #, " ",
  whole( count string in string("abab", "ababababab"), 0 )        # expect 2 #, " ",
  whole( count string in string("a*b", "abaabba*bbaba*bbab"), 0 ) # expect 2 #, newline
))
