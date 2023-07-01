main:(
  MODE STRINT = UNION(STRING, INT, PROC(REF FILE)VOID, VOID);

  PROC print strint = (FLEX[]STRINT argv)VOID: (
    FOR i TO UPB argv DO
      CASE argv[i] IN
        (INT i):print(whole(i,-1)),
        (STRING s):print(s),
        (PROC(REF FILE)VOID f):f(stand out),
        (VOID):print(error char)
      ESAC;
      IF i NE UPB argv THEN print((" ")) FI
    OD
  );

 print strint(("Mary","had",1,"little",EMPTY,new line))
)
