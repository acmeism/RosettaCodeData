PROC good page = (REF STRING page) BOOL:
     IF grep in string("^HTTP/[0-9.]* 200", page, NIL, NIL) = 0
     THEN TRUE
     ELSE IF INT start, end;
              grep in string("^HTTP/[0-9.]* [0-9]+ [a-zA-Z ]*", page,
                             start, end) = 0
          THEN print (page[start : end])
          ELSE print ("unknown error retrieving page")
          FI;
          FALSE
     FI;

MODE LISTOFSTRING = STRUCT(REF LINK first, last, INT upb);
MODE LINK = STRUCT(STRING value, REF LINK next);

PRIO LISTINIT = 1;
OP LISTINIT = (REF LISTOFSTRING new, REF LINK first)REF LISTOFSTRING: (
  new := (first, first, (first IS REF LINK(NIL) | 0 | 1 ));
  new
);

OP +:=  = (REF LISTOFSTRING list, []CHAR item)VOID: (
  HEAP LINK new := (STRING(item), REF LINK(NIL));
  IF first OF list IS REF LINK(NIL) THEN
    first OF list := new
  ELSE
    next OF last OF list := new
  FI;
  last OF list := new;
  upb OF list +:= 1
);

OP UPB = (LISTOFSTRING list)INT: upb OF list;

OP ARRAYOFSTRING = (LISTOFSTRING list)[]STRING:(
  [UPB list]STRING out;
  REF LINK this := first OF list;
  FOR i TO UPB list DO out[i] := value OF this; this := next OF this OD;
  out
);

INT match=0, no match=1, out of memory error=2, other error=3;

PROC re split = (STRING re split, REF STRING beetles)[]STRING:(
    LISTOFSTRING out := (NIL, NIL, 0); # LISTINIT REF LINK NIL; #
    INT start := 1, pos, end;
    WHILE grep in string(re split, beetles[start:], pos, end) = match DO
      out +:= beetles[start:start+pos-2];
      out +:= beetles[start+pos-1:start+end-1];
      start +:= end
    OD;
    IF start > UPB beetles THEN
      out +:= beetles[start:]
    FI;
    ARRAYOFSTRING(out)
  );


IF STRING reply;
   INT rc =
      http content (reply, "www.rosettacode.org", "http://www.rosettacode.org/w/index.php?title=Special:Categories&limit=500", 0);
   rc /= 0 OR NOT good page (reply)
THEN print (("Error:",strerror (rc)))
ELSE
  STRING  # hack: HTML should be parsed by an official HTML parsing library #
    re html tag = "<[^>]*>",
    re a href category = "^<a href=""/wiki/Category:.*"" title=",
    re members = "([1-9][0-9]* members)";

  MODE STATISTIC = STRUCT(INT members, STRING category);
  FLEX[0]STATISTIC stats;

  OP +:=  = (REF FLEX[]STATISTIC in out, STATISTIC item)VOID:(
      [LWB in out: UPB in out+1]STATISTIC new;
      new[LWB in out: UPB in out]:=in out;
      new[UPB new]:=item;
      in out := new
    );

# hack: needs to be manually maintained #
  STRING re ignore ="Programming Tasks|WikiStubs|Maintenance/OmitCategoriesCreated|"+
                    "Unimplemented tasks by language|Programming Languages|"+
                    "Solutions by Programming Language|Implementations|"+
                    "Solutions by Library|Encyclopedia|Language users|"+
                    "Solutions by Programming Task|Basic language learning|"+
                    "RCTemplates|Language Implementations";

  FORMAT category fmt = $"<a href=""/wiki/Category:"g""" title=""Category:"g""""$;
  STRING encoded category, category;
  FORMAT members fmt = $" ("g" members)"$;
  INT members;

  FLEX[0]STRING tokens := re split(re html tag, reply);
  FOR token index TO UPB tokens DO
    STRING token := tokens[token index];
    FILE file;
    IF grep in string(re a href category, token, NIL, NIL) = match THEN
      associate(file, token);
      make term(file,"""");
      getf(file, (category fmt, encoded category, category));
      close(file)
    ELIF grep in string(re members, token, NIL, NIL) = match THEN
      IF grep in string(re ignore, category, NIL, NIL) /= match THEN
        associate(file, token);
        getf(file, (members fmt, members));
        stats +:= STATISTIC(members, category);
        close(file)
      FI
    FI
  OD;

  OP < = (STATISTIC a,b)BOOL:
    members OF a < members OF b;

  MODE SORTSTRUCT = STATISTIC;
  PR READ "prelude/sort.a68" PR;

  stats := in place shell sort reverse(stats);

  INT max = 10;
  FOR i TO (UPB stats > max | max | UPB stats) DO
    printf(($g(-0)". "g(-0)" - "gl$,i,stats[i]))
  OD
FI
