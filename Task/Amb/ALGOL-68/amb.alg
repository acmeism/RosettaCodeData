MODE PAGE = FLEX[0]STRING;
MODE YIELDPAGE = PROC(PAGE)VOID;
MODE ITERPAGE = PROC(YIELDPAGE)VOID;

OP INITITERPAGE = (PAGE self)ITERPAGE:
  (YIELDPAGE yield)VOID: # scope violation #
    FOR i TO UPB self DO
      yield(self[i])
    OD;

OP + = (ITERPAGE for strings, PAGE b)ITERPAGE:
  (YIELDPAGE yield)VOID: # scope violation #
    for strings((PAGE amb)VOID:(
      [UPB amb + 1]STRING joined;
      joined[:UPB amb] := amb;
      STRING last string := amb[UPB amb];
      CHAR last char := last string[UPB last string];
      FOR i TO UPB b DO
        IF last char = b[i][1] THEN
          joined[UPB joined] := b[i];
          yield(joined)
        FI
      OD
    ));

OP + = (PAGE a, PAGE b)ITERPAGE: INITITERPAGE a + b;

ITERPAGE gen amb :=
   PAGE("the", "that", "a") +
   PAGE("frog", "elephant", "thing") +
   PAGE("walked", "treaded", "grows") +
   PAGE("slowly", "quickly");

PAGE sep;
#FOR PAGE amb IN # gen amb( # ) DO #
##  (PAGE amb)VOID:
    print((amb[1]+" "+amb[2]+" "+amb[3]+" "+amb[4], new line))
#OD# )
