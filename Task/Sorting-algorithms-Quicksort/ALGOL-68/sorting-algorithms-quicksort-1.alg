PROC partition =(REF [] DATA array, PROC (REF DATA, REF DATA) BOOL cmp)INT: (
  INT begin:=LWB array;
  INT end:=UPB array;
  WHILE begin < end DO
     WHILE begin < end DO
      IF cmp(array[begin], array[end]) THEN
        DATA tmp=array[begin];
        array[begin]:=array[end];
        array[end]:=tmp;
        GO TO break while decr end
      FI;
      end -:= 1
    OD;
    break while decr end: SKIP;
     WHILE begin < end DO
      IF cmp(array[begin], array[end]) THEN
        DATA tmp=array[begin];
         array[begin]:=array[end];
        array[end]:=tmp;
        GO TO break while incr begin
      FI;
      begin +:= 1
     OD;
     break while incr begin: SKIP
  OD;
  begin
);

PROC qsort=(REF [] DATA array, PROC (REF DATA, REF DATA) BOOL cmp)VOID: (
  IF LWB array < UPB array THEN
    INT i := partition(array, cmp);
    PAR ( # remove PAR for single threaded sort #
      qsort(array[:i-1], cmp),
      qsort(array[i+1:], cmp)
    )
  FI
);

MODE DATA = INT;
PROC cmp=(REF DATA a,b)BOOL: a>b;

main:(
  []DATA const l=(5,4,3,2,1);
  [UPB const l]DATA l:=const l;
  qsort(l,cmp);
  printf(($g(3)$,l))
)
