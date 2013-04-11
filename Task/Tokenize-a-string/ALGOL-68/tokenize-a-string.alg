main:(

  OP +:=  = (REF FLEX[]STRING in out, STRING item)VOID:(
    [LWB in out: UPB in out+1]STRING new;
    new[LWB in out: UPB in out]:=in out;
    new[UPB new]:=item;
    in out := new
  );

  PROC string split = (REF STRING beetles, STRING substr)[]STRING:(
    """ Split beetles where substr is found """;
    FLEX[1:0]STRING out;
    INT start := 1, pos;
    WHILE string in string(substr, pos, beetles[start:]) DO
      out +:= STRING(beetles[start:start+pos-2]);
      start +:= pos + UPB substr - 1
    OD;
    IF start > LWB beetles THEN
      out +:= STRING(beetles[start:])
    FI;
    out
  );

  PROC char split = (REF STRING beetles, STRING chars)[]STRING: (
    """ Split beetles where character is found in chars """;
    FLEX[1:0]STRING out;
    FILE beetlef;
    associate(beetlef, beetles); # associate a FILE handle with a STRING   #
    make term(beetlef, chars);   # make term: assign CSV string terminator #

    PROC raise logical file end = (REF FILE f)BOOL: except logical file end;
    on logical file end(beetlef, raise logical file end);

    STRING solo;
    DO
      getf(beetlef, ($g$, solo));
      out+:=solo;
      getf(beetlef, ($x$)) # skip CHAR separator #
    OD;
    except logical file end:
      SKIP;
    out
  );

  STRING beetles := "John Lennon, Paul McCartney, George Harrison, Ringo Starr";

  printf(($g"."$, string split(beetles, ", "),$l$));
  printf(($g"."$, char   split(beetles, ", "),$l$))
)
